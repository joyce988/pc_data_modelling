from pathlib import Path
import csv
import pandas as pd
import matplotlib.pyplot as plt
from matplotlib import ticker

try:
    import seaborn as sns
    sns.set(style="whitegrid", palette="muted")
except ImportError:
    sns = None

DATA_FILE = Path(__file__).resolve().parent / '1772542271737_pc_data (2).csv'
OUTPUT_DIR = Path(__file__).resolve().parent / 'analysis_output'
OUTPUT_DIR.mkdir(exist_ok=True)

RENAME_MAP = {
    'Continent': 'continent',
    'Country or State': 'country_or_state',
    'Province or City': 'province_or_city',
    'Shop Name': 'shop_name',
    'Shop Age': 'shop_age',
    'PC Make': 'pc_make',
    'PC Model': 'pc_model',
    'Storage Type': 'storage_type',
    'Customer Name': 'customer_name',
    'Customer Surname': 'customer_surname',
    'Customer Contact Number': 'customer_contact_number',
    'Customer Email Address': 'customer_email_address',
    'Sales Person Name': 'sales_person_name',
    'Sales Person Department': 'sales_person_department',
    'Cost Price': 'cost_price',
    'Sale Price': 'sale_price',
    'Payment Method': 'payment_method',
    'Discount Amount': 'discount_amount',
    'Purchase Date': 'purchase_date',
    'Ship Date': 'ship_date',
    'Finance Amount': 'finance_amount',
    'RAM': 'ram',
    'Credit Score': 'credit_score',
    'Channel': 'channel',
    'Priority': 'priority',
    'Cost of Repairs': 'cost_of_repairs',
    'Total Sales per Employee': 'total_sales_per_employee',
    'PC Market Price': 'pc_market_price',
    'Storage Capacity': 'storage_capacity'
}

NUMERIC_COLUMNS = [
    'shop_age',
    'cost_price',
    'sale_price',
    'discount_amount',
    'finance_amount',
    'credit_score',
    'cost_of_repairs',
    'total_sales_per_employee',
    'pc_market_price'
]

DATE_COLUMNS = ['purchase_date', 'ship_date']

CATEGORY_COLUMNS = [
    'continent',
    'country_or_state',
    'province_or_city',
    'shop_name',
    'pc_make',
    'storage_type',
    'payment_method',
    'channel',
    'priority'
]


def load_and_clean_data(path: Path) -> pd.DataFrame:
    df = pd.read_csv(path, encoding='utf-8', skipinitialspace=True)
    df.rename(columns=RENAME_MAP, inplace=True)

    for col in NUMERIC_COLUMNS:
        if col in df.columns:
            df[col] = pd.to_numeric(df[col].astype(str).str.replace('[^0-9.-]', '', regex=True), errors='coerce')

    for col in DATE_COLUMNS:
        if col in df.columns:
            df[col] = pd.to_datetime(df[col].replace({'N/A': None, 'n/a': None}), errors='coerce')

    df['customer_full_name'] = df[['customer_name', 'customer_surname']].fillna('').agg(' '.join, axis=1).str.strip()
    df['sale_year_month'] = df['purchase_date'].dt.to_period('M')
    df['profit'] = df['sale_price'] - df['cost_price']
    return df


def save_figure(fig, filename: str) -> None:
    filepath = OUTPUT_DIR / filename
    fig.tight_layout()
    fig.savefig(filepath, dpi=150)
    plt.close(fig)
    print(f'Saved {filepath}')


def plot_categorical_counts(df: pd.DataFrame, column: str, top_n: int = 10) -> None:
    counts = df[column].fillna('UNKNOWN').value_counts().nlargest(top_n)
    fig, ax = plt.subplots(figsize=(10, 6))
    counts.plot(kind='bar', ax=ax, color='#4c72b0')
    ax.set_title(f'Top {top_n} {column.replace("_", " ").title()}')
    ax.set_ylabel('Count')
    ax.set_xlabel(column.replace('_', ' ').title())
    ax.bar_label(ax.containers[0], padding=3)
    save_figure(fig, f'top_{top_n}_{column}.png')


def plot_numeric_distribution(df: pd.DataFrame, column: str, bins: int = 40) -> None:
    series = df[column].dropna()
    if series.empty:
        return
    fig, ax = plt.subplots(figsize=(10, 6))
    ax.hist(series, bins=bins, color='#f28e2b', edgecolor='black')
    ax.set_title(f'Distribution of {column.replace("_", " ").title()}')
    ax.set_xlabel(column.replace('_', ' ').title())
    ax.set_ylabel('Frequency')
    save_figure(fig, f'distribution_{column}.png')


def plot_time_series(df: pd.DataFrame) -> None:
    monthly = (
        df.dropna(subset=['sale_year_month', 'sale_price'])
        .groupby('sale_year_month')['sale_price']
        .agg(['sum', 'mean', 'count'])
        .reset_index()
    )
    if monthly.empty:
        return
    monthly['sale_year_month'] = monthly['sale_year_month'].astype(str)

    fig, ax = plt.subplots(figsize=(12, 6))
    ax.plot(monthly['sale_year_month'], monthly['sum'], marker='o', label='Total Sale Price')
    ax.plot(monthly['sale_year_month'], monthly['mean'], marker='o', label='Average Sale Price')
    ax.set_title('Monthly Sale Price Trends')
    ax.set_xlabel('Month')
    ax.set_ylabel('Sale Price')
    ax.legend()
    ax.tick_params(axis='x', rotation=45)
    save_figure(fig, 'monthly_sale_trends.png')


def plot_scatter(df: pd.DataFrame, x: str, y: str) -> None:
    data = df[[x, y]].dropna()
    if data.empty:
        return
    fig, ax = plt.subplots(figsize=(10, 6))
    ax.scatter(data[x], data[y], alpha=0.6, color='#59a14f', edgecolor='w', linewidth=0.5)
    ax.set_title(f'{y.replace("_", " ").title()} vs {x.replace("_", " ").title()}')
    ax.set_xlabel(x.replace('_', ' ').title())
    ax.set_ylabel(y.replace('_', ' ').title())
    save_figure(fig, f'scatter_{x}_vs_{y}.png')


def plot_correlation_matrix(df: pd.DataFrame) -> None:
    numeric = df[NUMERIC_COLUMNS].dropna(axis=1, how='all')
    corr = numeric.corr()
    if corr.empty:
        return
    fig, ax = plt.subplots(figsize=(10, 8))
    if sns is not None:
        sns.heatmap(corr, annot=True, fmt='.2f', cmap='coolwarm', ax=ax, cbar_kws={'shrink': 0.7})
    else:
        cax = ax.matshow(corr, cmap='coolwarm')
        fig.colorbar(cax)
        ax.set_xticks(range(len(corr.columns)))
        ax.set_yticks(range(len(corr.columns)))
        ax.set_xticklabels(corr.columns, rotation=90)
        ax.set_yticklabels(corr.columns)
        for i in range(len(corr.columns)):
            for j in range(len(corr.columns)):
                ax.text(j, i, f'{corr.iat[i, j]:.2f}', ha='center', va='center', color='white')
    ax.set_title('Numeric Correlation Matrix')
    save_figure(fig, 'correlation_matrix.png')


def build_summary_report(df: pd.DataFrame) -> pd.DataFrame:
    report = {
        'Total Rows': len(df),
        'Unique Customers': df['customer_full_name'].nunique() if 'customer_full_name' in df else None,
        'Period Start': df['purchase_date'].min(),
        'Period End': df['purchase_date'].max(),
        'Average Sale Price': df['sale_price'].mean(),
        'Median Sale Price': df['sale_price'].median(),
        'Total Sale Amount': df['sale_price'].sum(),
        'Total Discount': df['discount_amount'].sum(),
        'Average Credit Score': df['credit_score'].mean(),
    }
    return pd.DataFrame.from_dict(report, orient='index', columns=['Value'])


def main() -> None:
    print('Loading data from:', DATA_FILE)
    df = load_and_clean_data(DATA_FILE)

    print('Creating summary report...')
    summary = build_summary_report(df)
    summary.to_csv(OUTPUT_DIR / 'summary_report.csv')
    print(summary)

    summary.to_markdown(OUTPUT_DIR / 'summary_report.md')
    print('Saved summary_report.csv and summary_report.md')

    for column in ['continent', 'country_or_state', 'payment_method', 'priority', 'channel', 'storage_type', 'pc_make']:
        if column in df.columns:
            plot_categorical_counts(df, column, top_n=10)

    for column in NUMERIC_COLUMNS:
        if column in df.columns:
            plot_numeric_distribution(df, column)

    plot_time_series(df)
    plot_scatter(df, 'cost_price', 'sale_price')
    plot_scatter(df, 'sale_price', 'profit')
    plot_correlation_matrix(df)

    print(f'All analysis files saved in: {OUTPUT_DIR}')


if __name__ == '__main__':
    main()
