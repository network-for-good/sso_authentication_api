# SsoAuthenticationApi

The SSO authentication API allows an NFG application to poll whether an email/password combination represents a a valid, authenticatable user.

It offers a single interface, and returns information about the user using http codes and a json packet.

## Request

To inquire about a user, other systems should submit a post to:

````
[domain]/sso_authentication_api/v1/admins/authentications
````

The domains are as follows:

* QA: api.sso-qa.givecorps.com
* Beta: api.networkforgood-beta.com
* Production: api.networkforgood.com

The post must include a JSON packet with the following information:

````
{ email: "email.example.com", password: "users password"}
````

The request must also include an Authorization header with a Bearer token that is appopriate for the environment.

## Response

The response will include on of the following http codes

### 500
There system encountered an issue in handling this request. It may be due to an invalid bearer token, a post with no parameters, or some other unrelated server problem. Ensure you are using the correct bearer token and attempt your request again.

### 200
Indicatees the user is a valid and authenticatable user. Includes the following information:

````
{
  id: Internal ID assigned to the user by the application
  first_name: first name of the user
  last_name: last name of the user
  email: email address of the user
  status: "active", "inactive, or "pending" (this may differ app to app)
  roles: A list (JSON array) of app specific roles
}
````

This user may have multiple accounts, but at least one of them was authenticateable. Others may not have been

### 401
Indicates the user exists within the app, but was not able to be authenticated. Returns the same user packet as for a 200 response

This user may have multiple accounts, none of which were authenticateable.

### 404
No matching user was found




