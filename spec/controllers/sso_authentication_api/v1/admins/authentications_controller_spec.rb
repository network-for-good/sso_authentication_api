require "rails_helper"
# require "../../app/controllers/sso_authentication_api/v1/admins/authentications_controller.rb"

shared_examples_for "an authorized admin" do
  it "should return a 200 response" do
    expect(subject).to have_http_status(200)
  end

  it "should return the admin's attributes" do
    expect(subject.body).to eq(serialized_result)
  end
end

shared_examples_for "an unauthorized admin" do
  it "should return 401 response" do
    expect(subject).to have_http_status(401)
  end

  it "should return the admin's attributes" do
    expect(subject.body).to eq(serialized_result)
  end
end

describe SsoAuthenticationApi::V1::Admins::AuthenticationsController do
  before do
    controller.request.env["HTTP_AUTHORIZATION"] = authorization
  end
  let(:default_params) { { format: :json, authorization: authorization } }
  let(:authorization) { "Bearer #{ qa_token }" }
  let(:qa_token) { "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6Ik1RdjVzaDZ6ZElvb3l2eHFER2M1c2dOVWdUUSIsImtpZCI6Ik1RdjVzaDZ6ZElvb3l2eHFER2M1c2dOVWdUUSJ9.eyJpc3MiOiJodHRwczovL2lkZW50aXR5LXFhMDUubmZnaHEub3JnIiwiYXVkIjoiaHR0cHM6Ly9pZGVudGl0eS1xYTA1Lm5mZ2hxLm9yZy9yZXNvdXJjZXMiLCJleHAiOjE2MzQ1OTgwNDksIm5iZiI6MTQ3NjgxMDA0OSwiY2xpZW50X2lkIjoiTmdmVDNzdGlEIiwiY2xpZW50X3BhcnRuZXJfaWQiOiIxMDA4NTMiLCJjbGllbnRfY2FwYWJpbGl0aWVzIjpbIjAiLCIxIiwiMiIsIjMiLCI0IiwiNiIsIjgiLCI5IiwiMTAiLCIxMSIsIjEyIiwiMTMiLCIxNCIsIjE1IiwiMTYiLCIxOCIsIjE5IiwiMjAiLCIyMSJdLCJjbGllbnRfY2FtcGFpZ25DYXBhYmlsaXRpZXMxMTU2NCI6WyIwIiwiMSIsIjUiLCI2IiwiNyIsIjgiLCI5Il0sImNsaWVudF9jYW1wYWlnbkNhcGFiaWxpdGllczEyNzQwIjpbIjAiLCIxIiwiNSIsIjYiLCI3IiwiOCIsIjkiLCIxMCJdLCJjbGllbnRfY2FtcGFpZ25DYXBhYmlsaXRpZXMxMjc0MiI6WyIwIiwiMSIsIjUiLCI2IiwiNyIsIjgiLCI5IiwiMTAiXSwiY2xpZW50X2NhbXBhaWduQ2FwYWJpbGl0aWVzMTI3MzgiOlsiMCIsIjEiLCI1IiwiNiIsIjciLCI4IiwiOSIsIjEwIl0sImNsaWVudF9jYW1wYWlnbkNhcGFiaWxpdGllczEyNzM2IjpbIjAiLCIxIiwiNSIsIjYiLCI3IiwiOCIsIjkiLCIxMCJdLCJjbGllbnRfY2FtcGFpZ25DYXBhYmlsaXRpZXMxMjc0MyI6WyIwIiwiMSIsIjUiLCI2IiwiNyIsIjgiLCI5IiwiMTAiXSwiY2xpZW50X2NhbXBhaWduQ2FwYWJpbGl0aWVzMTI3MzkiOlsiMCIsIjEiLCI1IiwiNiIsIjciLCI4IiwiOSIsIjEwIl0sImNsaWVudF9jYW1wYWlnbkNhcGFiaWxpdGllczEyNzM3IjpbIjAiLCIxIiwiNSIsIjYiLCI3IiwiOCIsIjkiLCIxMCJdLCJjbGllbnRfY2FtcGFpZ25DYXBhYmlsaXRpZXMxMjc0MSI6WyIwIiwiMSIsIjUiLCI2IiwiNyIsIjgiLCI5IiwiMTAiXSwiY2xpZW50X2NhbXBhaWduQ2FwYWJpbGl0aWVzMTI3MjMiOlsiMCIsIjEiLCI1IiwiNiIsIjciLCI4IiwiOSIsIjEwIl0sImNsaWVudF9jYW1wYWlnbkNhcGFiaWxpdGllczEyNzM1IjpbIjAiLCIxIiwiNSIsIjYiLCI3IiwiOCIsIjkiLCIxMCJdLCJjbGllbnRfY2FtcGFpZ25DYXBhYmlsaXRpZXMxMDQ5MSI6WyIwIiwiMSIsIjQiLCI1IiwiNiIsIjciLCI4IiwiOSJdLCJjbGllbnRfY2FtcGFpZ25DYXBhYmlsaXRpZXMxMTY2OSI6WyIwIiwiMSIsIjUiLCI2IiwiNyIsIjgiLCI5Il0sImNsaWVudF9jYW1wYWlnbkNhcGFiaWxpdGllczExNjUxIjpbIjAiLCIxIiwiNSIsIjYiLCI3IiwiOCIsIjkiXSwic2NvcGUiOlsiZG9uYXRpb24iLCJkb25hdGlvbi1yZXBvcnRpbmciLCJpZG1nciJdLCJqdGkiOiI3Y2NmNzBlOGZkNjY0NGE4ZGMxYWMwY2NiYzU4MDk0ZSJ9.i2fyyPJq_ko8HBJxChrH7upV4lDu1vAba6EToQvznoAaMwrJkoGdKp78LtyAxpKtZVItR8mEH97XcFmZxiTY9Vof3ShWFLtPjzzVyxM3pjNQuzzzEJTgA7Vm4-dGGue4cm4JMsqhuW6h_c8JAHISHnscjguTsx6wNldykLPAEFniUMLo_c_WF1GenRAM0xGiqjz3wmugJ7KFsrl4_8WW6-GzfEyMp5CRNjyeiUs9_aL5Z2qDfvIo0ewWf6Hr7Cz0CYZxHeWtbazx2nZU10UQuhi5LMwN-65NRrSAaQeuUlBZWVvrau5HYKcA5PbKEH_g4ME1Hy-WwZpahvTJQ7gpqA" }
  routes { SsoAuthenticationApi::Engine.routes }
  let(:serialized_result) { ActiveModelSerializers::SerializableResource.new(resource,
                            serializer: SsoAuthenticationApi::V1::AdminSerializer).to_json }
  let(:resource) { admin }

  describe "#create" do
    let!(:admin) { Admin.new }
    let(:email) { "jon@example.com" }
    let(:password) { "myt3stPass!" }
    let(:authenticated) { true }
    let(:admins) { [] }

    subject { post :create, params }

    context "with an invalid authorization token" do
      let(:qa_token) { "baz" }
      let(:params) { default_params.merge(email: email, password: password) }

      it "should return a 500 error" do
        expect(subject).to have_http_status(500)
      end
    end

    context "when no params are included" do
      let(:params) { nil }

      it "should return a 500 error" do
        expect(subject).to have_http_status(500)
      end
    end

    context "when the params match the email of one admin" do
      let(:params) { default_params.merge(email: email, password: password) }

      before do
        allow(admin).to receive(:valid_password?).with(password).and_return(authenticated)
        allow(Admin).to receive(:where).with(email: email).and_return(admins)
      end

      let(:admins) { [admin] }
      context "and the password params also matches" do
        let(:authenticated) { true }

        it_should_behave_like "an authorized admin"
      end


      context "and the password param does not match" do
        let(:authenticated) { false }
        let(:password) { "not a matching password" }

        it_should_behave_like "an unauthorized admin"
      end

      context "and the passord params is blank" do
        let(:password) { "" }
        let(:authenticated) { false }

        it_should_behave_like "an unauthorized admin"
      end

      context "and no password param is included" do
        let(:params) { default_params.merge(email: email) }
        let(:password) { nil }
        let(:authenticated) { false }

        it_should_behave_like "an unauthorized admin"
      end
    end

    context "when the email params does not match any admins" do

      before do
        allow(admin).to receive(:valid_password?).with(password).and_return(authenticated)
        allow(Admin).to receive(:where).with(email: email).and_return(admins)
      end

      let(:admins) { [] }
      let(:params) { default_params.merge(email: email, password: "aisid") }
      let(:email) { "not@matching.com" }

      it "should return a 404" do
        expect(subject).to have_http_status(404)
      end
    end

    context "when the params match the email of multiple admins" do

      before do
        allow(admin).to receive(:valid_password?).with(password).and_return(authenticated)
        allow(Admin).to receive(:where).with(email: email).and_return(admins)
      end

      before do
        allow(admin2).to receive(:valid_password?).with(password).and_return(false)
      end
      let(:admins) { [admin, admin2] }
      let(:password2) { "myothertestpasSw0rd!" }
      let(:admin2) { Admin.new }

      context "and none of them can be authenticated using the passed password" do
        let(:params) { default_params.merge(email: email, password: password) }
        let(:authenticated) { false }

        it "should return a 401 error" do
          expect(subject).to have_http_status(401)
        end
      end

      context "and one of them can be authenticated using the passed password" do
        let(:params) { default_params.merge(email: email, password: password) }
        let(:authenticated) { true }

        it_should_behave_like "an authorized admin"
      end
    end
  end
end