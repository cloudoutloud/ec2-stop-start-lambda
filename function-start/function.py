# python lambda function
import boto3

def lambda_handler(event, context):

    #Get's a list of all region
    ec2_client = boto3.client('ec2')
    regions = [region['RegionName']
               for region in ec2_client.describe_regions()['Regions']]

    #Iterate over each region
    for region in regions:
        ec2 = boto3.resource('ec2', region_name=region)
        
        #Show in Cloudwatch logs
        print("Region", region)
    
        #Get only stopped instances
        instances = ec2.instances.filter(
            Filters=[{'Name': 'instance-state-name',
                     'Values': ['stopped']}])

        # Stop the instances
        for instance in instances:
            instance.start()
            
            #Show in Cloudwatch logs
            print('Started instance: ', instance.id) 
