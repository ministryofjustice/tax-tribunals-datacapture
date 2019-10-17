package simulations

import io.gatling.core.Predef._
import io.gatling.http.Predef._
import scala.concurrent.duration._
import com.typesafe.config._



class Close extends Simulation
with HttpConfiguration
{
  val conf = ConfigFactory.load()
  val baseurl = conf.getString("baseUrl")
  val httpconf = httpProtocol.baseURL(baseurl).disableCaching

  val scenario1 = scenario("Apply to close an enquiry")

    .exec(http("Closure")
        .get("/closure")
        .check(status.is(200)))

    .exec(http("Case type")
        .get("/steps/closure/case_type")
        .formParam("steps_closure_case_type_form[closure_case_type]", "personal_return")
        .check(status.is(200)))

    .exec(http("User type")
        .get("/steps/details/user_type")
        .formParam("steps_details_user_type_form[user_type]", "taxpayer")
        .check(status.is(200)))
    
    .exec(http("Taxpayer type")
        .get("/steps/details/taxpayer_type")
        .formParam("steps_details_taxpayer_type_form[taxpayer_type]", "individual")
        .check(status.is(200)))

    .exec(http("Taxpayer details")
        .get("/steps/details/taxpayer_details")
        .formParam("steps_details_taxpayer_individual_details_form[taxpayer_individual_first_name]", "John")
        .formParam("steps_details_taxpayer_individual_details_form[taxpayer_individual_last_name]", "Smith")
        .formParam("steps_details_taxpayer_individual_details_form[taxpayer_individual_address]", "102 Petty France")
        .formParam("steps_details_taxpayer_individual_details_form[taxpayer_individual_city]", "London")
        .formParam("steps_details_taxpayer_individual_details_form[taxpayer_individual_postcode]", "SW1H 9AJ")
        .formParam("steps_details_taxpayer_individual_details_form[taxpayer_individual_country]", "UK")
        .formParam("steps_details_taxpayer_individual_details_form[taxpayer_individual_email]", "john.smith@gmail.com")
        .check(status.is(200)))

    .exec(http("Taxpayer type")
        .get("/steps/details/has_representative")
        .formParam("steps_details_has_representative_form[has_representative]", "no")
        .check(status.is(200)))

    .exec(http("Enquiry details")
        .get("/steps/closure/enquiry_details")
        .formParam("steps_closure_enquiry_details_form[closure_hmrc_reference]", "test")
        .formParam("steps_closure_enquiry_details_form[closure_years_under_enquiry]", "1")
        .check(status.is(200)))

    .exec(http("Additional info")
        .get("/steps/closure/additional_info")
        .formParam("steps_closure_additional_info_form[closure_additional_info]", "Test")
        .check(status.is(200)))

    .exec(http("Check your answers")
        .get("/steps/closure/check_answers")
        .check(status.is(200)))

  val userCount = conf.getInt("users")
  val durationInSeconds  = conf.getLong("duration")

  setUp(
    scenario1.inject(rampUsers(userCount) over (durationInSeconds seconds)).protocols(httpconf)
  )

}
