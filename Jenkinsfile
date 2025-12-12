// Jenkinsfile (الـ Groovy Script المُعدّل للعمل على جهاز افتراضي واحد)

pipeline {
    // جميع المراحل ستعمل على العامل الرئيسي (master/built-in)
    agent any 
    
    stages {
        stage('Checkout Code') {
            steps {
                echo 'Pulling the latest code from GitHub...'
                // خطوة أساسية لضمان سحب الكود في بداية كل تشغيل
                checkout scm
            }
        }
        
        stage('Build - Docker Image') {
            // يتم البناء على العامل الرئيسي
            agent { label 'master' } 
            steps {
                echo 'Starting Docker Image Build...'
                // بناء الصورة مع وسم فريد باستخدام رقم البناء
                sh 'docker build -t dvna-image:${env.BUILD_NUMBER} .'
                echo 'Docker Image Built Successfully: dvna-image:${env.BUILD_NUMBER}'
            }
        }

        stage('Deploy To Test Environment') {
            // يتم النشر على نفس الجهاز، باستخدام منفذ مختلف لحاوية الاختبار
            agent { label 'master' } 
            steps {
                echo 'Deploying application to Test Environment (Port 8081)...'
                // 1. إيقاف وإزالة أي حاوية اختبار قديمة (لضمان التشغيل النظيف)
                sh 'docker stop dvna_test || true'
                sh 'docker rm dvna_test || true'
                
                // 2. تشغيل حاوية التطبيق على منفذ مختلف (8081)
                // المنفذ الخارجي 8081 يشير إلى المنفذ الداخلي 3000 للتطبيق
                sh 'docker run -d --name dvna_test -p 8081:3000 dvna-image:${env.BUILD_NUMBER}'
                echo 'Test Deployment Completed. Access via http://<VM-IP>:8081'
            }
        }

        // هذا القسم سيتم تعديله لاحقاً عند إضافة WAF و Nginx (DevSecOps stages)
        stage('Deploy To Production') {
            // يتم النشر على نفس الجهاز، باستخدام منفذ الإنتاج الافتراضي (80)
            agent { label 'master' } 
            steps {
                echo 'Deploying application to Production Environment (Port 80)...'
                // 1. إيقاف وإزالة أي حاوية إنتاج قديمة
                sh 'docker stop dvna_prod || true'
                sh 'docker rm dvna_prod || true'
                
                // 2. تشغيل حاوية التطبيق على منفذ 80
                sh 'docker run -d --name dvna_prod -p 80:3000 dvna-image:${env.BUILD_NUMBER}'
                echo 'Production Deployment Completed. Access via http://<VM-IP>'
            }
        }
    }
}
