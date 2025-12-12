// Jenkinsfile (الـ Groovy Script المُعدّل للعمل على جهاز افتراضي واحد)

pipeline {
    // استخدم أي عامل متاح، وهو في حالتنا هو العقدة الرئيسية (Built-in Node)
    agent any 
    
    stages {
        stage('Checkout Code') {
            steps {
                echo 'Pulling the latest code from GitHub...'
                // سحب الكود من المستودع
                checkout scm
            }
        }
        
        stage('Build - Docker Image') {
            // تنفيذ البناء على العقدة الرئيسية التي تم إعداد صلاحيات Docker عليها
            agent { label 'master' } 
            steps {
                echo 'Starting Docker Image Build...'
                // بناء الصورة مع وسم فريد باستخدام رقم البناء (مثلاً dvna-image:6)
                // يجب أن يتوفر ملف Dockerfile صحيح في جذر المستودع
                sh 'docker build -t dvna-image:${env.BUILD_NUMBER} .'
                echo "Docker Image Built Successfully: dvna-image:${env.BUILD_NUMBER}"
            }
        }

        stage('Deploy To Test Environment') {
            // النشر على نفس الجهاز، باستخدام منفذ مختلف للاختبار
            agent { label 'master' } 
            steps {
                echo 'Deploying application to Test Environment (Port 8081)...'
                // 1. إيقاف وإزالة أي حاوية اختبار قديمة (لضمان التشغيل النظيف)
                sh 'docker stop dvna_test || true'
                sh 'docker rm dvna_test || true'
                
                // 2. تشغيل حاوية التطبيق على منفذ 8081 الخارجي
                sh 'docker run -d --name dvna_test -p 8081:3000 dvna-image:${env.BUILD_NUMBER}'
                echo 'Test Deployment Completed. Access via http://<VM-IP>:8081'
            }
        }

        stage('Deploy To Production') {
            // النشر على نفس الجهاز، باستخدام منفذ الإنتاج الافتراضي
            agent { label 'master' } 
            steps {
                echo 'Deploying application to Production Environment (Port 80)...'
                // 1. إيقاف وإزالة أي حاوية إنتاج قديمة
                sh 'docker stop dvna_prod || true'
                sh 'docker rm dvna_prod || true'
                
                // 2. تشغيل حاوية التطبيق على منفذ 80 الخارجي
                sh 'docker run -d --name dvna_prod -p 80:3000 dvna-image:${env.BUILD_NUMBER}'
                echo 'Production Deployment Completed. Access via http://<VM-IP>'
            }
        }
    }
}
