pipeline{
    agent none
    stages{
        stage("Get Code from Git"){
            agent { label 'master' }
            steps{
               git 'https://github.com/juan-m-m/project-devops'
            }
            
        }
        stage("Build"){
            agent { docker 'node:10.9' }
			steps{
                 sh "npm install"
                 sh '$(npm bin)/ng build --prod --build-optimizer'
            }
        }
        stage("Archive artifact"){
            agent { label 'master' }
            steps{
               archiveArtifacts 'dist/angular7-docker/*.js'
            }
        }
		stage("Package"){
            agent { label ' master' }
            steps{
               sh "docker build -t project_devops_app:v1 ."
               sh "docker save -o project_devops.tar project_devops_app:v1"
               stash name: "stash-artifact", includes: "project_devops.tar"
               
               
            }
        }
        stage("Deploy to QA"){
            agent { label ' master' }
            steps{
                sh "docker rm project_devops_app -f || true"
                sh "docker run -d -p 4200:4200 --name project_devops_app project_devops_app:v1"
            }
        }
        stage("Get Automation Code from Git"){
            agent { label 'master' }
            steps{
               git 'https://github.com/W1LLY/angular-automation'
            }
            
        }
        stage("Run Automation tests"){
            agent { label 'master' }
            steps{
                sh "docker rm browser -f || true"
                sh "docker run -d -p 4444:4444 --name browser --link project_devops_app selenium/standalone-chrome"
                sh "mvn test"
            }
            
        }
         stage("Generate Automation report"){
            agent{label "master"}
            steps{
                cucumber buildStatus: 'UNSTABLE',
                fileIncludePattern: 'target/*.json',
                trendsLimit: 10,
                classifications: [
                    [
                        'key': 'Browser',
                        'value': 'Chrome'
                    ]
                ]
            }
        }
        stage("Deploy ansible"){
            agent { label 'master' }
            steps{
               sh 'ansible-playbook playbook.yml'
            }
        }

    }
}
