package simulations

import io.gatling.core.Predef._
import io.gatling.http.Predef._
import scala.concurrent.duration._
import com.typesafe.config._



class StaffAppPerformance extends Simulation
with HttpConfiguration
{
  val conf = ConfigFactory.load()
  val baseurl = conf.getString("baseUrl")
  val httpconf = httpProtocol.baseURL(baseurl).disableCaching

  val scenario1 = scenario("Happy path for Help with Fees staff app")

    .exec(http("Store authenticity token")
        .get("/users/sign_in")
        .check(css("input[name='authenticity_token']", "value").saveAs("csrfCookie")))

    .exec(http("Sign in")
        .put("/users/sign_in")
        .formParam("user[email]", conf.getString("userEmail"))
        .formParam("user[password]", conf.getString("userPassword"))
        .formParam("authenticity_token", session => {
              session("csrfCookie").as[String]
        })
        .check(status.is(200)))

    .exec(http("Paper application - Personal details")
        .get("/applications/733032/personal_informations")
        .formParam("application[first_name]", "Testy")  
        .formParam("application[last_name]", "McTest-Face")
        .formParam("application[day_date_of_birth]", "01")
        .formParam("application[month_date_of_birth]", "02")
        .formParam("application[year_date_of_birth]", "1974")
        .formParam("application[married]", "false")
        .formParam("authenticity_token", session => {
              session("csrfCookie").as[String]
        })
        .check(status.is(200)))

    .exec(http("Paper application - Application details")
        .get("/applications/733032/details")
        .formParam("application[fee]", "500")
        .formParam("application[jurisdiction_id]", "1")
        .formParam("application[day_date_received]", "01")
        .formParam("application[month_date_received]", "06")
        .formParam("application[year_date_received]", "2019")
        .formParam("application[form_name]", "C100")
        .formParam("authenticity_token", session => {
              session("csrfCookie").as[String]
        })
        .check(status.is(200)))

    .exec(http("Paper application - Savings and investments")
        .get("/applications/733032/savings_investments")
        .formParam("application[min_threshold_exceeded]", "false")
        .formParam("authenticity_token", session => {
              session("csrfCookie").as[String]
        })
        .check(status.is(200)))

    .exec(http("Paper application - Benefits")
        .get("/applications/7330321/benefits")
        .formParam("application[benefits]", "false")
        .formParam("authenticity_token", session => {
              session("csrfCookie").as[String]
        })
        .check(status.is(200)))

    .exec(http("Paper application - Income")
        .get("/applications/7330321/incomes")
        .formParam("application[dependents]", "false")
        .formParam("application[income]", "500")
        .formParam("authenticity_token", session => {
              session("csrfCookie").as[String]
        })
        .check(status.is(200)))

    .exec(http("Paper application - Summary")
        .get("/applications/7330321/summary")
        .formParam("authenticity_token", session => {
              session("csrfCookie").as[String]
        })
        .check(status.is(200)))

    .exec(http("Paper application - Confirmation")
        .get("/applications/7330321/confirmation")
        .formParam("authenticity_token", session => {
              session("csrfCookie").as[String]
        })
        .check(status.is(200)))



  val userCount = conf.getInt("users")
  val durationInSeconds  = conf.getLong("duration")

  setUp(
    scenario1.inject(rampUsers(userCount) over (durationInSeconds seconds)).protocols(httpconf)
  )

}
