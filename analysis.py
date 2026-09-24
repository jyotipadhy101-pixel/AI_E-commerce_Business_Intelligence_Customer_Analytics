import pandas as pd
import matplotlib.pyplot as plt

df = pd.read_csv("dataset/Sample - Superstore.csv", encoding="latin1")

print("\nFirst 5 Rows")
print(df.head())

print("\nDataset Shape")
print(df.shape)

print("\nColumn Names")
print(df.columns)

print("\nMissing Values")
print(df.isnull().sum())

print("\nDuplicate Rows")
print(df.duplicated().sum())

print("\nSales Analysis")
print("Total Sales:", df["Sales"].sum())
print("Average Sales:", df["Sales"].mean())

print("\nProfit Analysis")
print("Total Profit:", df["Profit"].sum())

print("\nSales by Category")
print(df.groupby("Category")["Sales"].sum())

print("\nSales by Region")
print(df.groupby("Region")["Sales"].sum())

print("\nTop 10 Customers")
print(df.groupby("Customer Name")["Sales"].sum().sort_values(ascending=False).head(10))

print("\nTop 10 Products")
print(df.groupby("Product Name")["Sales"].sum().sort_values(ascending=False).head(10))

category_sales = df.groupby("Category")["Sales"].sum()

plt.figure(figsize=(8,5))
category_sales.plot(kind="bar")
plt.title("Sales by Category")
plt.xlabel("Category")
plt.ylabel("Total Sales")
plt.xticks(rotation=0)
plt.tight_layout()
plt.savefig("screenshots/sales_by_category.png")
plt.show()

region_sales = df.groupby("Region")["Sales"].sum()

plt.figure(figsize=(6,6))
region_sales.plot(kind="pie", autopct="%1.1f%%")
plt.title("Sales by Region")
plt.ylabel("")
plt.savefig("screenshots/sales_by_region.png")
plt.show()

df["Order Date"] = pd.to_datetime(df["Order Date"],errors="coerce")
print(df["Order Date"].head())
print(df["Order Date"].dtype)

monthly_sales = df.groupby(df["Order Date"].dt.to_period("M"))["Sales"].sum()
monthly_sales.index = monthly_sales.index.astype(str)

plt.figure(figsize=(10,5))
monthly_sales.plot(kind="line", marker="o")
plt.title("Monthly Sales Trend")
plt.xlabel("Month")
plt.ylabel("Sales")
plt.xticks(rotation=45)
plt.tight_layout()
plt.savefig("screenshots/monthly_sales_trend.png")
plt.show()

plt.figure(figsize=(8,5))
plt.hist(df["Profit"], bins=30)
plt.title("Profit Distribution")
plt.xlabel("Profit")
plt.ylabel("Frequency")
plt.tight_layout()
plt.savefig("screenshots/profit_distribution.png")
plt.show()

import pandas as pd
import matplotlib.pyplot as plt

df = pd.read_csv("dataset/Sample - Superstore.csv")

profit_by_category = df.groupby("Category")["Profit"].sum().sort_values(ascending=False)

profit_by_category.plot(kind="bar")
plt.title("Profit by Category")
plt.xlabel("Category")
plt.ylabel("Total Profit")
plt.xticks(rotation=0)
plt.tight_layout()

plt.savefig("screenshots/profit_by_category.png")
plt.show()