import os
import snowflake.connector
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

# 1. Retina Display Optimization for Mac Books
# This ensures lines and text are crisp and high-resolution on your screen
plt.rcParams['figure.dpi'] = 150 
plt.rcParams['savefig.dpi'] = 300

# 2. Establish Connection to Snowflake
ctx = snowflake.connector.connect(
    user='snowflake_username',
    password='snowflake_password',
    account='snowflake_Account_identifier',
    warehouse='snowwflake_warehouse',
    database='snowflake_DB',
    schema='Snowflake_schema',
    role='snowflake_role'
)

cursor = ctx.cursor()


# 3. Pull Data from your Gold Layer View
query = """
    SELECT 
        STORE_ID, 
        ISHOLIDAY, 
        SUM(WEEKLY_SALES)/1000000 as TOTAL_SALES
    FROM WMT_DB.GOLD.WMT_FACT_VIEW
    GROUP BY STORE_ID, ISHOLIDAY
    ORDER BY STORE_ID ASC;
"""

try:
    # --- THIS WAS THE MISSING STEP CREATING 'df' ---
    cursor.execute(query)
    df = cursor.fetch_pandas_all() 
    # -----------------------------------------------
finally:
    # Cleanly close connection objects
    cursor.close()
    ctx.close()

# 4. Create a grouped bar chart
plt.figure(figsize=(14, 6))

sns.barplot(
    data=df, 
    x='STORE_ID', 
    y='TOTAL_SALES', 
    hue='ISHOLIDAY', 
    palette='muted'
)

# Add styling, labels, and titles
plt.title('Weekly Sales by Store ID: Holiday vs Non-Holiday Weeks', fontsize=14, pad=15, weight='bold')
plt.xlabel('Store ID', fontsize=11)
plt.ylabel('Total Sales ($)', fontsize=11)

# Format the legend cleanly
plt.legend(title='Is Holiday?', loc='upper right', frameon=True)

# Clean layout and display
plt.grid(axis='y', linestyle=':', alpha=0.6)
plt.tight_layout()
plt.show()
