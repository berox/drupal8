node('php') {
    stage 'Checkout Projet'
        git branch: 'master', credentialsId: 'jenkins-private-key', url: '[drupal_git_url]'

    stage 'Composer Install'
        sh 'composer install --prefer-dist --no-interaction --ignore-platform-reqs'
        sh 'composer dumpautoload --no-interaction'

    stage 'Analyse Code'
        sh './bin/spbuilder analyze --ignore-tool visualization'

    stage 'Publish Results'
        step([$class: 'CheckStylePublisher', canComputeNew: false, defaultEncoding: '', healthy: '', pattern: 'build/logs/checkstyle.xml,build/logs/smileanalyser.xml', unHealthy: ''])
        step([$class: 'PmdPublisher', canComputeNew: false, defaultEncoding: '', healthy: '', pattern: 'build/logs/pmd.xml', unHealthy: ''])
        step([$class: 'DryPublisher', canComputeNew: false, defaultEncoding: '', healthy: '', pattern: 'build/logs/cpd.xml', unHealthy: ''])
        step([
            $class: 'ViolationsPublisher',
            violationConfigs: [
                [ pattern: 'build/logs/checkstyle.xml,build/logs/smileanalyser.xml', reporter: 'CHECKSTYLE' ],
                [ pattern: 'build/logs/pmd.xml', reporter: 'PMD' ],
                [ pattern: 'build/logs/cpd.xml', reporter: 'CPD' ]
            ]
        ])
        sh './bin/SmileAnalyser push --job_url ${JOB_URL} --build ${BUILD_NUMBER}'

    stage 'Package'
        sshagent(['jenkins-private-key']) {
            sh './bin/spbuilder package --force-name="[git_group_name]-[git_project_name]" --force-version="${BUILD_TAG}"'
        }

    stage 'Provision'
        sshagent(['jenkins-private-key']) {
            sh './architecture/scripts/provision.sh inte'
        }

    stage 'Deploy'
        sshagent(['jenkins-private-key']) {
            sh './architecture/scripts/deploy.sh inte -p "${BUILD_TAG}" -s'
            sh './architecture/scripts/drupal.sh inte smilereconfigure:apply-conf -e inte -c y'
            sh './architecture/scripts/cache-clean.sh inte'
        }
}