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
  let(:qa_token) { "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJlbnYiOiJ0ZXN0In0.rl1JEgm37TY3yvXVbK6D6gUWWrjRtJKd8NtlF0Kgbz0" }

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

    subject { post :create, params: params }

    context "with an invalid authorization token" do
      let(:qa_token) { "baz" }
      let(:params) { default_params.merge(email: email, password: password) }

      it "should return a 500 error" do
        expect(subject).to have_http_status(500)
      end
    end

    context "when no params are included" do
      let(:params) { {} }

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