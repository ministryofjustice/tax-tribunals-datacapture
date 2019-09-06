package simulations

import io.gatling.core.Predef._
import io.gatling.http.Predef._
import scala.concurrent.duration._
import com.typesafe.config._



class Performance extends Simulation
with HttpConfiguration
{
  val conf = ConfigFactory.load()
  val baseurl = conf.getString("baseUrl")
  val httpconf = httpProtocol.baseURL(baseurl).disableCaching

  val scenario1 = scenario("Happy path for appeal against a tax decision")

    .exec(http("Store authenticity token")
        .get("/appeal")
        .check(css("input[name='authenticity_token']", "value").saveAs("csrfCookie")))

    .exec(http("Appeal")
        .get("/users/sign_in")
        .formParam("authenticity_token", session => {
              session("csrfCookie").as[String]
        })
        .check(status.is(200)))

    .exec(http("Case type")
        .get("/steps/appeal/case_type")
        .formParam("steps_appeal_case_type_form[case_type]", "income_tax")
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
