📊 Crime Insights and Trends Dashboard

A comprehensive data analytics project that visualizes crime trends, patterns, and case resolutions using AWS services and Tableau. The dashboard provides actionable insights for law enforcement and policymakers by identifying crime hotspots, seasonal patterns, case closure rates, and yearly crime rate comparisons.

🚀 Project Overview

This project analyzes crime data stored in AWS S3, processed using AWS Glue, queried with AWS Athena, and visualized through Tableau. The key objective is to derive meaningful insights from historical crime data and present them interactively to support data-driven decision-making.

⚡ Key Features

🌆 Crime Hotspots: Highlights the top 10 cities with the highest crime counts, with Delhi leading at 1,181 cases.

🔍 Top Crime Types: Lists the most common crime types reported in 2020, including theft and assault.

📅 Crime Distribution by Day: Displays weekly crime trends, showing consistent distribution across all weekdays.

🌿 Seasonal Crime Patterns: Visualizes crime distribution across different seasons, with summer witnessing the highest occurrences.

🕵️ Case Resolution Analysis: Analyzes open vs. closed cases, revealing a 49.96% closure rate.

📉 Yearly Crime Rate Comparison: Compares yearly crime trends, showing a 41.4% decrease in 2024, marking significant progress in crime control.

⚙️ Technologies Used

AWS Athena: For querying data efficiently using SQL.

AWS S3: Storage for raw and processed datasets.

AWS Glue: ETL operations for data transformation.

Tableau: For creating interactive dashboards.

SQL: For data querying and analysis.

🛠️ Project Structure

├── data/
│   └── crime_dataset/ (Stored in AWS S3)
├── etl/
│   └── glue_jobs/ (AWS Glue scripts)
├── queries/
│   └── queries.sql (All SQL queries used for Athena)
├── dashboard/
│   └── crime_dashboard.twb (Tableau dashboard file)
└── README.md (Project documentation)

💡 Insights from the Dashboard

🏙️ Delhi: Highest crime count with 1,181 cases, highlighting the need for focused mitigation strategies.

📅 Weekly Distribution: Crime occurrences remain consistent throughout the week, differing by fewer than 100 cases per day.

🔎 Top Crime Types: Theft and assault are the most frequently reported crimes.

🌞 Seasonal Trends: Summer records the highest number of crimes among all seasons.

🏛️ Case Resolution: 49.96% of total cases are closed, reflecting moderate resolution efforts.

📉 Yearly Trends: A notable 41.4% drop in crime cases between 2023 and 2024, suggesting effective crime control measures.

🌟 Key Insights & Recommendations

Highest Crime Rate: Delhi leads in crime count, requiring targeted law enforcement policies.

Yearly Crime Trends: 2024 showed a 41.4% reduction in crime compared to 2023. Identifying factors contributing to this drop can guide future strategies.

Case Closure Trends: A closure rate of nearly 50% suggests room for improvement in case resolution processes.

Consistent Weekly Trends: Daily crime patterns suggest that resources should be allocated evenly across the week.

Seasonal Impact: Higher crime rates in summer may indicate the need for seasonal policing strategies.

These insights are prominently highlighted in the dashboard using interactive tooltips, color-coded charts, and dynamic filters for better user engagement.

📈 How to Use the Dashboard

Clone the Repository:

git clone https://github.com/pallavirani123/crime-insights-dashboard.git

Open in Tableau:

Launch Tableau and load the crime_dashboard.twbx file from the dashboard/ folder.

Execute SQL Queries:

Open the queries/queries.sql file.

Run queries in AWS Athena with appropriate database and table references.

💬 Contributing

Contributions are welcome! Please feel free to open issues or submit pull requests for improvements or additional insights.

📝 License

This project is open-source and available under the MIT License.

✨ Acknowledgments

AWS documentation for service integration guidance.

Tableau community for best practices in data visualization.

Open datasets utilized for crime analysis.

🔥 Explore the Dashboard and Unlock Crime Insights! 🚀
