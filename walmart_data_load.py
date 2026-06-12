import boto3
import os
from botocore.exceptions import ClientError, NoCredentialsError

# Use explicit keyword argument for region
s3_resource = boto3.resource('s3', region_name='us-east-1') 

def s3_upload(file_name, fold, bkt):
    try:
        # Verify the file actually exists right where python expects it
        if not os.path.exists(file_name):
            print(f"❌ LOCAL ERROR: Cannot find '{file_name}' in {os.getcwd()}")
            return False
            
        s3_bucket = s3_resource.Bucket(name=bkt)
        s3_bucket.upload_file(
            Filename=file_name,
            Key=fold + '/' + file_name
        )
        return True
    except Exception as e:
        # CRITICAL FIX: Print the exact system exception message 
        print(f"❌ UPLOAD CRASHED BECAUSE: {type(e).__name__} - {e}")
        return False

if __name__ == '__main__':
    file_name = 'stores.csv'
    s3_folder = 'data'
    bucket = 'walmart-endtoend-871049984307-us-east-1-an'
    
    status = s3_upload(file_name, s3_folder, bucket)
    
    if status:
        print('🎉 Success! Data is saved to S3.')
    else:
        print('⚠️ Upload failed.')
