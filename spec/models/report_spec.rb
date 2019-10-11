# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Report, type: :model do
  let(:valid_repo) { Report.new(url: 'https://github.com/rails/rails') }
  let(:invalid_repo) { Report.new(url: 'https://github.com/boom') }

  describe '.github_repo_identifier' do
    context 'when the report is valid' do
      it 'returns the repo identifier' do
        expect(valid_repo.github_repo_identifier).to eq('rails/rails')
      end
    end

    context 'when the report is invalid' do
      it 'returns nil' do
        expect(invalid_repo.github_repo_identifier).to be_nil
      end
    end
  end

  describe '.save' do
    context 'when the report is valid' do
      before do
        allow(ReportAirtableUpdaterService)
          .to receive(:call).and_return(false)
      end

      it 'calls the ReportAirtableUpdaterService' do
        valid_repo.save
        expect(ReportAirtableUpdaterService)
          .to have_received(:call).with(valid_repo).once
      end

      it 'always returns true' do
        expect(valid_repo.save).to eq(true)
      end
    end

    context 'when the report is invalid' do
      it 'returns false' do
        expect(invalid_repo.save).to eq(false)
      end
    end
  end
end
