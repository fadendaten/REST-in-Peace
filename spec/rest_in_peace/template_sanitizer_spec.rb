require 'rest_in_peace/template_sanitizer'

describe RESTinPeace::TemplateSanitizer do

  let(:template_sanitizer) { RESTinPeace::TemplateSanitizer.new(url_template, params) }

  describe '#url' do
    subject { template_sanitizer.url }

    context 'single token' do
      let(:params) { { id: 1 } }
      let(:url_template) { '/a/:id' }
      specify { expect(subject).to eq('/a/1') }
    end

    context 'multiple token' do
      let(:params) { { id: 2, a_id: 1 } }
      let(:url_template) { '/a/:a_id/b/:id' }
      specify { expect(subject).to eq('/a/1/b/2') }
    end

    context 'incomplete params' do
      let(:params) { {} }
      let(:url_template) { '/a/:id' }
      specify { expect { subject }.to raise_error(RESTinPeace::TemplateSanitizer::IncompleteParams) }
    end

    context 'mutability of the url template' do
      let(:params) { { id: 1 } }
      let(:url_template) { '/a/:id' }
      specify { expect { subject }.to_not change { url_template } }
    end
  end

  describe '#tokens' do
    let(:params) { {} }

    context 'single token' do
      let(:url_template) { '/a/:id' }
      subject { template_sanitizer.tokens }
      specify { expect(subject).to eq(%w(id)) }
    end

    context 'multiple tokens' do
      let(:url_template) { '/a/:a_id/b/:id' }
      subject { template_sanitizer.tokens }
      specify { expect(subject).to eq(%w(a_id id)) }
    end
  end

end
