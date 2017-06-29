require 'rails_helper'

describe SsoAuthenticationApi::TokenDecoder do
  let(:decoder_class) { SsoAuthenticationApi::TokenDecoder }
  let(:decoder) { decoder_class.decode(token) }
  let(:token) { "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6Ik1RdjVzaDZ6ZElvb3l2eHFER2M1c2dOVWdUUSIsImtpZCI6Ik1RdjVzaDZ6ZElvb3l2eHFER2M1c2dOVWdUUSJ9.eyJpc3MiOiJodHRwczovL2lkZW50aXR5LXFhMDUubmZnaHEub3JnIiwiYXVkIjoiaHR0cHM6Ly9pZGVudGl0eS1xYTA1Lm5mZ2hxLm9yZy9yZXNvdXJjZXMiLCJleHAiOjE2MzQ1OTgwNDksIm5iZiI6MTQ3NjgxMDA0OSwiY2xpZW50X2lkIjoiTmdmVDNzdGlEIiwiY2xpZW50X3BhcnRuZXJfaWQiOiIxMDA4NTMiLCJjbGllbnRfY2FwYWJpbGl0aWVzIjpbIjAiLCIxIiwiMiIsIjMiLCI0IiwiNiIsIjgiLCI5IiwiMTAiLCIxMSIsIjEyIiwiMTMiLCIxNCIsIjE1IiwiMTYiLCIxOCIsIjE5IiwiMjAiLCIyMSJdLCJjbGllbnRfY2FtcGFpZ25DYXBhYmlsaXRpZXMxMTU2NCI6WyIwIiwiMSIsIjUiLCI2IiwiNyIsIjgiLCI5Il0sImNsaWVudF9jYW1wYWlnbkNhcGFiaWxpdGllczEyNzQwIjpbIjAiLCIxIiwiNSIsIjYiLCI3IiwiOCIsIjkiLCIxMCJdLCJjbGllbnRfY2FtcGFpZ25DYXBhYmlsaXRpZXMxMjc0MiI6WyIwIiwiMSIsIjUiLCI2IiwiNyIsIjgiLCI5IiwiMTAiXSwiY2xpZW50X2NhbXBhaWduQ2FwYWJpbGl0aWVzMTI3MzgiOlsiMCIsIjEiLCI1IiwiNiIsIjciLCI4IiwiOSIsIjEwIl0sImNsaWVudF9jYW1wYWlnbkNhcGFiaWxpdGllczEyNzM2IjpbIjAiLCIxIiwiNSIsIjYiLCI3IiwiOCIsIjkiLCIxMCJdLCJjbGllbnRfY2FtcGFpZ25DYXBhYmlsaXRpZXMxMjc0MyI6WyIwIiwiMSIsIjUiLCI2IiwiNyIsIjgiLCI5IiwiMTAiXSwiY2xpZW50X2NhbXBhaWduQ2FwYWJpbGl0aWVzMTI3MzkiOlsiMCIsIjEiLCI1IiwiNiIsIjciLCI4IiwiOSIsIjEwIl0sImNsaWVudF9jYW1wYWlnbkNhcGFiaWxpdGllczEyNzM3IjpbIjAiLCIxIiwiNSIsIjYiLCI3IiwiOCIsIjkiLCIxMCJdLCJjbGllbnRfY2FtcGFpZ25DYXBhYmlsaXRpZXMxMjc0MSI6WyIwIiwiMSIsIjUiLCI2IiwiNyIsIjgiLCI5IiwiMTAiXSwiY2xpZW50X2NhbXBhaWduQ2FwYWJpbGl0aWVzMTI3MjMiOlsiMCIsIjEiLCI1IiwiNiIsIjciLCI4IiwiOSIsIjEwIl0sImNsaWVudF9jYW1wYWlnbkNhcGFiaWxpdGllczEyNzM1IjpbIjAiLCIxIiwiNSIsIjYiLCI3IiwiOCIsIjkiLCIxMCJdLCJjbGllbnRfY2FtcGFpZ25DYXBhYmlsaXRpZXMxMDQ5MSI6WyIwIiwiMSIsIjQiLCI1IiwiNiIsIjciLCI4IiwiOSJdLCJjbGllbnRfY2FtcGFpZ25DYXBhYmlsaXRpZXMxMTY2OSI6WyIwIiwiMSIsIjUiLCI2IiwiNyIsIjgiLCI5Il0sImNsaWVudF9jYW1wYWlnbkNhcGFiaWxpdGllczExNjUxIjpbIjAiLCIxIiwiNSIsIjYiLCI3IiwiOCIsIjkiXSwic2NvcGUiOlsiZG9uYXRpb24iLCJkb25hdGlvbi1yZXBvcnRpbmciLCJpZG1nciJdLCJqdGkiOiI3Y2NmNzBlOGZkNjY0NGE4ZGMxYWMwY2NiYzU4MDk0ZSJ9.i2fyyPJq_ko8HBJxChrH7upV4lDu1vAba6EToQvznoAaMwrJkoGdKp78LtyAxpKtZVItR8mEH97XcFmZxiTY9Vof3ShWFLtPjzzVyxM3pjNQuzzzEJTgA7Vm4-dGGue4cm4JMsqhuW6h_c8JAHISHnscjguTsx6wNldykLPAEFniUMLo_c_WF1GenRAM0xGiqjz3wmugJ7KFsrl4_8WW6-GzfEyMp5CRNjyeiUs9_aL5Z2qDfvIo0ewWf6Hr7Cz0CYZxHeWtbazx2nZU10UQuhi5LMwN-65NRrSAaQeuUlBZWVvrau5HYKcA5PbKEH_g4ME1Hy-WwZpahvTJQ7gpqA" }
  let!(:public_key) { certificate.public_key }
  let(:cert_file_path) { File.join(Rails.root, 'config', 'public_key_certs', file_name) }
  let(:certificate) { OpenSSL::X509::Certificate.new(File.read(cert_file_path)) }
  let(:file_name) { 'nfg_qa.cer' }

  before(:each) do
    # since we are using class variables, we need to reload
    # the class between tests to ensure we are getting the correct
    # versions of the certs
    SsoAuthenticationApi.send(:remove_const, 'TokenDecoder')
    load 'sso_authentication_api/token_decoder.rb'
  end

  describe ".certificate" do
    subject { decoder_class.certificate }

    context 'when using the primary certificate' do
      it "should return the OpenSSL version of the qa cert" do
        cert_file = File.read(cert_file_path)
        expect(File).to receive(:read).with(cert_file_path).and_return(cert_file)
        expect(OpenSSL::X509::Certificate).to receive(:new).with(cert_file)
        subject
      end

      context "when running in production" do
        before do
          allow(Rails).to receive(:env).and_return(ActiveSupport::StringInquirer.new("production"))
        end
        let(:file_name) { 'nfg_production.cer' }

        it "should return the OpenSSL version of the production cert" do
          cert_file = File.read(cert_file_path)
          expect(File).to receive(:read).with(cert_file_path).and_return(cert_file)
          expect(OpenSSL::X509::Certificate).to receive(:new).with(cert_file)
          subject
        end
      end
    end

    context "when using the secondary certificate" do
      subject { decoder_class.certificate(true) }
      let(:file_name) { 'nfg_qa_secondary.cer' }

      it "should return the OpenSSL version of the qa secondary cert" do
        cert_file = File.read(cert_file_path)
        expect(File).to receive(:read).with(cert_file_path).and_return(cert_file)
        expect(OpenSSL::X509::Certificate).to receive(:new).with(cert_file)
        subject
      end

      context "when running in production" do
        before do
          allow(Rails).to receive(:env).and_return(ActiveSupport::StringInquirer.new("production"))
        end
        let(:file_name) { 'nfg_production_secondary.cer' }

        it "should return the OpenSSL version of the production cert" do
          cert_file = File.read(cert_file_path)
          expect(File).to receive(:read).with(cert_file_path).and_return(cert_file)
          expect(OpenSSL::X509::Certificate).to receive(:new).with(cert_file)
          subject
        end
      end
    end
  end

  describe ".public_key" do
    subject { decoder_class.public_key }

    context "when using the primary certificate" do
      it "should return the public key associated with the current environment" do
        expect(certificate).to receive(:public_key).and_return(public_key)
        expect(decoder_class).to receive(:certificate).and_return(certificate)
        expect(subject).to eq(public_key)
      end
    end

    context "when using the secondary certificate" do
      subject { decoder_class.public_key(true) }

      it "should return the public key associated with the current environment" do
        expect(certificate).to receive(:public_key).and_return(public_key)
        expect(decoder_class).to receive(:certificate).with(true).and_return(certificate)
        expect(subject).to eq(public_key)
      end
    end
  end

  describe ".decode" do
    let(:decoded_token) { JWT.decode(token, public_key, true, { algorithm: "RS256" }) }
    subject { decoder_class.decode(token) }

    it "should return a decoded token" do
      expect(subject).to eq(decoded_token)
    end

    context 'when the token was generated from the secondary certificate' do
      let(:token) { "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6InRlUDlQYkUzcEd1dFZBYjZNMXRNaEhmUjY0SSIsImtpZCI6InRlUDlQYkUzcEd1dFZBYjZNMXRNaEhmUjY0SSJ9.eyJpc3MiOiJodHRwczovL2lkZW50aXR5LXVhdC5uZXR3b3JrZm9yZ29vZC5vcmciLCJhdWQiOiJodHRwczovL2lkZW50aXR5LXVhdC5uZXR3b3JrZm9yZ29vZC5vcmcvcmVzb3VyY2VzIiwiZXhwIjoxNjU1NDI1NjczLCJuYmYiOjE0OTc2Mzc2NzMsImNsaWVudF9pZCI6Im5mZ3dlYmFwaSIsImNsaWVudF9wYXJ0bmVyX2lkIjoiMTAwMjMxIiwiY2xpZW50X2NhcGFiaWxpdGllcyI6WyI1IiwiNyIsIjgiLCI5IiwiMTAiLCIxMSIsIjEyIiwiMjEiXSwiY2xpZW50X2NhbXBhaWduQ2FwYWJpbGl0aWVzMTA2NzIiOiIwIiwiY2xpZW50X2NhbXBhaWduQ2FwYWJpbGl0aWVzMTA4NDEiOiIwIiwiY2xpZW50X2NhbXBhaWduQ2FwYWJpbGl0aWVzMTA4NDIiOiIwIiwiY2xpZW50X2NhbXBhaWduQ2FwYWJpbGl0aWVzMTA4NDMiOiIwIiwiY2xpZW50X2NhbXBhaWduQ2FwYWJpbGl0aWVzMTA4NjIiOlsiMCIsIjEwIl0sImNsaWVudF9jYW1wYWlnbkNhcGFiaWxpdGllczExMzkyIjpbIjAiLCI5IiwiMTAiXSwic2NvcGUiOlsiZG9uYXRpb24iLCJkb25hdGlvbi1yZXBvcnRpbmciLCJpZG1nciJdLCJqdGkiOiJhODAwN2FhNTI0NDJlNzQyZmNhNjEwMWU2ZTRmY2YxMCJ9.Km_IwEWQPBino1xhvIdfCOH1zdj7BA5k_RQ59reUx1x9rosacB5LbKSEDz2tg71dwzHq9hOLzC0Uf4MJyr76AojD-1CyDbPR1X0UekDhWUPq4JB8TZ5QgX8pGTVURIeRFTosP_8fLjM11pIvNexKvoFZ8YTyzUTfvZUaydMgmruamwHBjtj2Mqcs-hgQCZV-6LGF8gPHMHOkEC1hzTQ83aG6Rc_mvLW8wzDho_1sah2LTRjQLlSBP8TT4Dcu_zv1JSND-7BmP8mJZeVYZeAgxwRwlTeNrB0JcOrQyrvoowSEw7BCFEtYRlvLYA34RBNsQqHCLVsYneA7y9AykvN8-Q" }
      let(:file_name) { 'nfg_qa_secondary.cer' }


      it "should return a decoded token" do
        expect(subject).to eq(decoded_token)
      end
    end
  end
end