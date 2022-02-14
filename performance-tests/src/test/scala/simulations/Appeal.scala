package simulations

import io.gatling.core.Predef._
import io.gatling.http.Predef._
import scala.concurrent.duration._
import com.typesafe.config._



class Appeal extends Simulation
with HttpConfiguration
{
  val conf = ConfigFactory.load()
  val baseurl = conf.getString("baseUrl")
  val httpconf = httpProtocol.baseURL(baseurl).disableCaching

  val scenario1 = scenario("Happy path for appeal against a tax decision")

    .exec(http("Appeal")
        .get("/appeal")
        .check(status.is(200)))

    .exec(http("Case type")
        .get("/steps/appeal/case_type")
        .formParam("steps_appeal_case_type_form[case_type]", "income_tax")
        .check(status.is(200)))

    .exec(http("Challenge decision")
        .get("/steps/challenge/decision")
        .formParam("steps_challenge_decision_form[challenged_decision]", "yes")
        .check(status.is(200)))

    .exec(http("Response received")
        .get("/steps/challenge/decision_status")
        .formParam("steps_challenge_decision_status_form[challenged_decision_status]", "received")
        .check(status.is(200)))

    .exec(http("Dispute type")
        .get("/steps/appeal/dispute_type")
        .formParam("steps_appeal_dispute_type_form[dispute_type]", "penalty")
        .check(status.is(200)))

    .exec(http("Penalty amount")
        .get("/steps/appeal/penalty_amount")
        .formParam("steps_appeal_penalty_amount_form[penalty_level]", "penalty_level_1")
        .check(status.is(200)))

    .exec(http("Within time")
        .get("/steps/lateness/in_time")
        .formParam("steps_lateness_in_time_form[in_time]", "unsure")
        .check(status.is(200)))

    .exec(http("Reason for being late")
        .get("/steps/lateness/lateness_reason")
        .formParam("steps_lateness_lateness_reason_form[lateness_reason]", "I was on holiday")
        .check(status.is(200)))

    .exec(http("Are you the taxpayer")
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
        .formParam("steps_details_taxpayer_individual_details_form[taxpayer_contact_address]", "102 Petty France")
        .formParam("steps_details_taxpayer_individual_details_form[taxpayer_contact_city]", "London")
        .formParam("steps_details_taxpayer_individual_details_form[taxpayer_contact_postcode]", "SW1H 9AJ")
        .formParam("steps_details_taxpayer_individual_details_form[taxpayer_contact_country]", "UK")
        .formParam("steps_details_taxpayer_individual_details_form[taxpayer_contact_email]", "john.smith@gmail.com")
        .check(status.is(200)))

    .exec(http("Has representative")
        .get("/steps/details/has_representative")
        .formParam("steps_details_has_representative_form[has_representative]", "no")
        .check(status.is(200)))

    .exec(http("Grounds for appeal")
        .get("/steps/details/grounds_for_appeal")
        .formParam("steps_details_grounds_for_appeal_form[grounds_for_appeal]", "Test")
        .check(status.is(200)))

    .exec(http("Outcome")
        .get("/steps/details/outcome")
        .formParam("steps_details_outcome_form[outcome]", "Test")
        .check(status.is(200)))

    .exec(http("Need support")
        .get("/steps/details/need_support")
        .formParam("steps_shared_need_support_form[need_support]", "yes")
        .check(status.is(200)))

    .exec(http("What support")
        .get("/steps/details/what_support")
        .formParam("steps_details_what_support_form[language_interpreter]", "1")
        .formParam("steps_details_what_support_form[language_interpreter_details]", "Chinese")
        .check(status.is(200)))

    .exec(http("Upload review conclusion letter")
        .get("/steps/details/letter_upload_type")
        .formParam("steps_details_letter_upload_type_form[letter_upload_type]", "no_letter")
        .check(status.is(200)))

    .exec(http("Save your appeal")
        .get("/users/sign_up")
        .formParam("user[email]", "john.smith@gmail.com")
        .formParam("user[password]", "password")
        .check(status.is(200)))

    .exec(http("Save confirmation")
        .get("/users/registration/save_confirmation")
        .check(status.is(200)))

    .exec(http("Login")
        .get("/users/login")
        .formParam("user[email]", "john.smith@gmail.com")
        .formParam("user[password]", "password")
        .check(status.is(200)))

  val userCount = conf.getInt("users")
  val durationInSeconds  = conf.getLong("duration")

  setUp(
    scenario1.inject(rampUsers(userCount) over (durationInSeconds seconds)).protocols(httpconf)
  )

}
