*** Settings ***
Library  SeleniumLibrary

*** Variables ***
${driver}                   Chrome
${base_url}                 https://search.bnservers.com/

                                #---------- search.bnservers data ----------#
#---------- Good login data ----------#
${username}                 bntester1111+4@gmail.com
${password}                 Testing123$

#---------- Bad login data ----------#
${bad_username}             clickabletester@gmail.com
${bad_password}             Testing123!

                                        #---------- iris data ----------#
${iris_url}                 https://go.bn.co/login/#/signin
${iris_username}            bntester1111+4@gmail.com
${iris_password}            Testing123$

                                        #---------- Amazon api data ----------#
${client_id}                amzn1.application-oa2-client.6315e0d367ef41c9b4a8f018c148eff0
${refresh_token}            Atzr|IwEBICLHlZiLweEECPbhIbsS8eCEqIh4dZ6OpUKkqB6skH7ze1KfG5LPMVpHFnkFLslzmIMrKEFZQPGe2TGImjwAtPAp98pX7QvuwukQpcWtzvwzTPAXmxaSfJqzwYdMm2jOFDIhg2GqCqlqRT0J2ZurCjry52Ts9AZ_jXqCSJyxj1RHvQ1vgOJkQW-6XmypKYKHz8fpXGKGOsLI4pTPoTVAg7QIDVQdzDapc9Q6OrrjWB9kYnXleivb-1NNSVSid8X8e0oxUDMu3Z57RCSZh_J0WRIGgBUKPa2Dj_pbndt9RDoGIZWodn8wjdG04dNQNdgS-ws27g60yaZ3UbNmqQM8KOi2gMNQsXuKvwMt0H2ygEP-8NXyI2cEtKvndg23cuwGKaM0XURfTF5RYlpdoRJ7l-p3BDFvqM5LhX9urhdetWQ_0K_T6Pqx3-dBQbYSJECl8CrVT9zGbXWl2RaFw7OW72vAuB6TivMG1c84gTOGYF2DJUqetd5A30WqeP-H8lScfcZbwzxmXA-RcAUPGtH8b4in9E_7nuh0oV5PCvthHweEXB7vs3g_55rchFjn4Q361e5gMYCR7rptRiBnJcZyHlsBCzUHk3wm_-aqn74qaDTUJYuuZAq6vOV4IRN6YK_W1ctQWPKkLQOM_dUJQME48aF4q1EVppTb9jMZC8uyRYICjCZ3BNZH0DJBkAAJMCVOdsk
${client_secret}            e386617cb79f864fe9ea45d40e11d24a9adcc46718e52cd4f19ae10220f6b6c7
${amazon_url}               https://advertising-api-test.amazon.com/v2
${amazon_oauth_url}         https://api.amazon.com/auth/o2             