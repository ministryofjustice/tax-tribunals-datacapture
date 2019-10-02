Dependencies
1. Docker
2. Gatling 


### Running Gatling tests locally

1. Start docker daemon 
2. From the performance-tests directory, run below to build your local docker container

    ```
    docker build -t ttgatling:local . 

    ```


3. From the performance-tests directory, run gatling scripts against docker image
   ```
   docker run --rm -e APP_URL=https://tax-tribunals-datacapture-staging.dsd.io/
   -v `pwd`/src/test/resources:/opt/gatling/conf -v `pwd`/src/test/scala/simulations:/opt/gatling/user-files/simulations -v `pwd`/results:/opt/gatling/results -v `pwd`/data:/opt/gatling/data ttgatling:local -s simulations.TaxTribunalsPerformance
   ```

Note: if you are on os x you will need to include the following in the above command `--add-host localhost:<IP>`

    
4. Reports folder will be created once tests successfully ran
