import pandas as pd
from sqlalchemy import create_engine
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import classification_report, accuracy_score

# PostgreSQL connection
engine = create_engine(
    "postgresql+psycopg2://postgres:Jyoti101@localhost:5432/ecommerce_db"
)

# Load customer data
query = """
SELECT
    customer_id,
    recency_days,
    total_orders,
    total_sales,
    recency_score,
    frequency_score,
    monetary_score,
    rfm_score,
    CASE
        WHEN recency_days > 90 THEN 1
        ELSE 0
    END AS churned
FROM customer_rfm;
"""

df = pd.read_sql(query, engine)

# Features
features = [
    "recency_days",
    "total_orders",
    "total_sales",
    "recency_score",
    "frequency_score",
    "monetary_score",
    "rfm_score"
]

X = df[features]
y = df["churned"]

# Split data
X_train, X_test, y_train, y_test = train_test_split(
    X,
    y,
    test_size=0.2,
    random_state=42,
    stratify=y
)

# Train model
model = RandomForestClassifier(
    n_estimators=200,
    random_state=42,
    class_weight="balanced"
)

model.fit(X_train, y_train)

# Evaluate
y_pred = model.predict(X_test)

print("Accuracy:", accuracy_score(y_test, y_pred))
print(classification_report(y_test, y_pred))

# Predict churn probability for every customer
df["churn_probability"] = model.predict_proba(X)[:, 1]

# Risk level
df["risk_level"] = pd.cut(
    df["churn_probability"],
    bins=[-0.01, 0.33, 0.66, 1.0],
    labels=["Low Risk", "Medium Risk", "High Risk"]
)

# Save predictions
df.to_csv("customer_churn_predictions.csv", index=False)

print("\nPrediction file created:")
print("customer_churn_predictions.csv")