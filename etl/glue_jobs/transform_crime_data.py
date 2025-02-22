import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from awsglue.dynamicframe import DynamicFrame
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job
from pyspark.sql.functions import col, to_date

# Initialize Glue Context
sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init("crime_data_etl_job")

# 🔹 Load data from Glue Data Catalog (linked to S3)
datasource = glueContext.create_dynamic_frame.from_catalog(
    database="crime_data_db1", 
    table_name="crime_data_bucket1"
)

# 🔹 Convert to Spark DataFrame for transformations
df = datasource.toDF()

# 🛠️ Data Cleaning and Transformation
df = df.dropna()  # Remove missing values
df = df.withColumn("DateReported", to_date(col("DateReported"), "yyyy-MM-dd"))  # Convert date format


# Convert back to Glue DynamicFrame
transformed_data = DynamicFrame.fromDF(df, glueContext)

# 🚀 Write Transformed Data to S3 (Parquet Format for Athena)
output_path = "s3://crime-data-bucket1/processed-data/"
glueContext.write_dynamic_frame.from_options(
    frame=transformed_data,
    connection_type="s3",
    connection_options={"path": output_path},
    format="parquet"
)

# Commit Job
job.commit()
