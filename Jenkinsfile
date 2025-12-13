pipeline {
    // استخدم أي عامل متاح، وهو في حالتنا هو العقدة الرئيسية (Built-in Node)
    agent any 
    
    stages {
        stage('Checkout Code') {
            steps {
                echo 'Pulling the latest code from GitHub...'
                // سحب الكود من المستودع (تعريفياً)
                checkout scm
            }
        }
        
        stage('Build - Docker Image') {
            // تنفيذ البناء على العقدة الرئيسية
            agent { label 'master' } 
            steps {
                echo 'Starting Docker Image Build...'
                // *** الإصلاح: استخدام الأقواس المزدوجة لتمرير المتغير env.BUILD_NUMBER ***
                sh "docker build -t dvna-image:${env.BUILD_NUMBER} ."
                echo "Docker Image Built Successfully: dvna-image:${env.BUILD_NUMBER}"
            }
        }

        stage('Deploy To Test Environment') {
            // النشر على نفس الجهاز، باستخدام منفذ 8081 للاختبار
            agent { label 'master' } 
            steps {
                echo 'Deploying application to Test Environment (Port 8081)...'
                // إيقاف وإزالة أي حاوية اختبار قديمة
                sh 'docker stop dvna_test || true'
                sh 'docker rm dvna_test || true'
                
                // تشغيل الحاوية الجديدة
                sh "docker run -d --name dvna_test -p 8081:3000 dvna-image:${env.BUILD_NUMBER}"
                echo 'Test Deployment Completed. Access via http://<VM-IP>:8081'
            }
        }

        stage('Deploy To Production') {
            // النشر على نفس الجهاز، باستخدام منفذ 80 للإنتاج
            agent { label 'master' } 
            steps {
                echo 'Deploying application to Production Environment (Port 80)...'
                // إيقاف وإزالة أي حاوية إنتاج قديمة
                sh 'docker stop dvna_prod || true'
                sh 'docker rm dvna_prod || true'
                
                // تشغيل الحاوية الجديدة
                sh "docker run -d --name dvna_prod -p 8000:3000 dvna-image:${env.BUILD_NUMBER}"
                echo 'Production Deployment Completed. Access via http://<VM-IP>'
            }
        }
    }
}
