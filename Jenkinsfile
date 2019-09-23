#!groovy
def region = 'eu-west-2'
def account_id = '<insert valid aws account id>'
def functionName1 = 'lambda_ec2_stop'
def functionName2 = 'lambda_ec2_start'


pipeline {

    agent {
      label 'master'
    }

    environment {
    PATH = "${env.WORKSPACE}/bin:${env.PATH}"
    }
    
    // Steps to deploy terraform infra
    stages {
        stage ('Initialise'){
            steps {
                dir('terraform/'){
                  sh "terraform init"
                }
            }
        }    

        stage ('validate'){
            steps {
               dir('terraform/'){
                 sh "terraform validate"
               }
            }
        }
        
        stage ('plan'){
            steps{
                dir('terraform/'){
                  sh "terraform plan -out=terraform.tfplan"
                }
            }
        }

        stage ('apply'){
            steps{
                timeout(time: 1, unit: 'HOURS') {
            input id: "ApplyPlan",
                  message: "Is this Terraform plan OK to apply and deploy into Production?"
            }
            dir ('terraform/'){
                sh "terraform apply terraform.tfplan"
               }
            }
        }

        stage ('output'){
            steps{
                dir('terraform/'){
                    sh "terraform output"
                }
            }
        }

        //Steps to deploy stop lambda function 1
        stage ('LambdaStopBuild'){
            steps{
                dir('function-stop/'){
                    sh "zip function.zip function.py"
                }
            }
        }

        stage ('LambdaStopDeploy'){
            steps{
                script{
                    withEnv(["AWS_ASSUME_ROLE=arn:aws:iam::${account_id}:role/pipeline-role-full-account-access"])
                    dir('function-stop/'){
                         sh "assume-role aws lambda update-function-code --function-name ${functionName1} \
                         --zip-file fileb://function.zip \
                         --region ${region}"
                    }
                }
            }
        }

        //Steps to deploy start lambda function 2
        stage ('LambdaStartBuild'){
            steps{
                dir('function-start/'){
                    sh "zip function.zip function.py"
                }
            }
        }

        stage ('LambdaStartDeploy'){
            steps{
                script{
                    withEnv(["AWS_ASSUME_ROLE=arn:aws:iam::${account_id}:role/pipeline-role-full-account-access"])
                    dir('function-start/'){
                         sh "assume-role aws lambda update-function-code --function-name ${functionName2} \
                         --zip-file fileb://function.zip \
                         --region ${region}"
                 }
             }
         }
      }

    //   stage ('delete'){
    //         steps{
    //             timeout(time: 1, unit: 'HOURS') {
    //         input id: "Delete",
    //               message: "Do you want to delete all infra"
    //         }
    //             dir ('terraform/'){
    //                 sh "terraform destroy -auto-approve"
    //             }
    //         }
    //     }
    }
}


