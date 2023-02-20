
pipeline {
    agent { label 'macos' }

    stages {


        stage('Flutter doctor') {
            steps {
                sh 'flutter doctor -v'
            }
        }
         stage('GIT PULL') {
            steps {
               git branch: 'main', credentialsId: 'Creds Git', url: 'https://github.com/sagaracharya24/KidsZone.git'
            }
        }
        stage('TEST') {
            steps {
                sh 'flutter test'
            }
        }
        // stage('Increament Build Number'){
        //     steps{
        //          sh '''
        //          set -e

        //         # Find and increment the version number.
        //         perl -i -pe 's/^(version:\s+\d+\.\d+\.\d+\+)(\d+)$/$1.($2+1)/e' client/pubspec.yaml

        //         # Commit and tag this change.
        //         version=`grep 'version: ' client/pubspec.yaml | sed 's/version: //'`
        //         git commit -m "Bump version to $version" client/pubspec.yaml
        //         git tag $version
        //          '''
        //     }
        // }
        stage('BUILD') {
            steps {
                sh '''
                  #!/bin/sh
                  flutter build apk --release
                  '''
            }
        }
          stage('Publish to AppCenter') {
           steps {

                appCenter apiToken: '31cfb1407f2a2b63a2c4cd485c8268363691ad0b',
                        ownerName: 'acharyasagar282-gmail.com',
                        appName: 'kidszone-android',
                        pathToApp: 'build/app/outputs/apk/debug/app-debug.apk',
                        distributionGroups: 'beta'
           }
        }
    }
}