Crime Data ETL Pipeline
This project implements an ETL pipeline using AWS Glue to process crime data. The pipeline extracts raw data from S3, transforms it by cleaning and restructuring it, and then loads the transformed data into S3 in a processed format.

Key Features
Data Extraction: Pulls raw crime data from S3.
Data Transformation: Cleans and formats the data, including handling date fields and removing unnecessary columns.
Data Loading: Writes the transformed data to a different S3 bucket for further analysis in formats such as Parquet.
Prerequisites
Before running the AWS Glue job, ensure the following:

AWS Glue Service Role with the necessary permissions to access your S3 buckets and Glue resources.
S3 Buckets for storing raw and processed data (e.g., s3://crime-data-bucket1/raw/ and s3://crime-data-bucket1/processed/).
AWS Glue Job configured with Spark as the ETL engine.
IAM Role Permissions as described below.
Job Overview
The crime_data_etl_job performs the following ETL steps:

1. Data Extraction
The job reads crime data in CSV format from an S3 bucket.
Source Path: s3://crime-data-bucket1/raw/
2. Data Transformation
The job performs the following transformations:
Converts the DateReported column into the YYYY-MM-DD format.
3. Data Loading
The transformed data is written back to another S3 bucket in the processed folder.
Destination Path: s3://crime-data-bucket1/processed/
Output Format: Parquet
The job is scheduled to run periodically to process new data files.

Job Parameters
The following parameters are used by the Glue job:

Source Path: s3://crime-data-bucket1/raw/
Destination Path: s3://crime-data-bucket1/processed/
Data Format: The raw data is in CSV format, and the output is written in Parquet format for optimized storage and analysis.
IAM Role: AWS Glue service role AWSGlueServiceRole-pallavi.
IAM Role Permissions
Ensure that the IAM role assigned to the Glue job has the following permissions:

S3 Permissions:
s3:GetObject and s3:PutObject for both the source and destination S3 buckets.
Glue Permissions:
glue:* permissions to read and write data in the Glue Data Catalog.
CloudWatch Permissions:
Permissions to log job outputs to CloudWatch for monitoring.
Example IAM Role policy for S3 permissions:

json
Copy
Edit
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:PutObject"
      ],
      "Resource": [
        "arn:aws:s3:::crime-data-bucket1/raw/*",
        "arn:aws:s3:::crime-data-bucket1/processed/*"
      ]
    }
  ]
}
Running the Job
To execute the ETL job, follow these steps:

Create the Glue Job:

Navigate to the AWS Glue Console.
Select Jobs and click Add Job.
Configure the job name (crime_data_etl_job), IAM role, and job settings.
Choose Python for the language, Spark as the engine, and select the appropriate worker type (e.g., G.1X).
Upload the Script:

You can upload the provided ETL script (or use the script editor in AWS Glue) to perform data extraction, transformation, and loading.
Example script available below.
Run the Job:

After creating the job, click Run Job to execute the ETL process.
Monitor the Job:

Monitor job status and logs via AWS CloudWatch.
If the job fails, review the CloudWatch logs to troubleshoot any errors.


ETL Script:
import sys
import boto3
from awsglue.utils import getResolvedOptions
from awsglue.context import GlueContext
from pyspark.context import SparkContext
from pyspark.sql import SparkSession
from pyspark.sql.functions import col, to_date

# Initialize Spark and Glue Context
sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session

# Read data from S3
data = glueContext.create_dynamic_frame.from_options(
    connection_type="s3",
    connection_options={"paths": ["s3://crime-data-bucket1/raw/"]},
    format="csv",
    format_options={"withHeader": True}
)

# Convert DynamicFrame to DataFrame
data_df = data.toDF()

# Transform data: Convert DateReported to proper date format
data_df = data_df.withColumn("report_date", to_date(col("DateReported"), "yyyy-MM-dd"))

# Optionally, drop the original DateReported column
data_df = data_df.drop("DateReported")

# Write the transformed data back to S3 in Parquet format
transformed_data = glueContext.create_dynamic_frame.fromDF(data_df, glueContext, "transformed_data")
glueContext.write_dynamic_frame.from_options(
    transformed_data,
    connection_type="s3",
    connection_options={"path": "s3://crime-data-bucket1/processed/"},
    format="parquet"
)

# Commit the job
job.commit()

Job Failure Troubleshooting
If the job fails, try the following troubleshooting steps:

Error: "Failed to find table": Make sure the database and table are created in Glue Data Catalog. Check if your data source exists and is properly registered in the catalog.
Error: "Concurrent Runs Exceeded": You may have reached the maximum allowed concurrent job runs. Consider adjusting the job’s concurrency settings or waiting for other jobs to finish.
Error: "Permission Denied": Ensure your IAM role has the correct permissions for S3 and Glue actions, as well as CloudWatch logging.
License
This project is licensed under the MIT License.

Additional Information
For more detailed information on AWS Glue, refer to the AWS Glue Documentation.

