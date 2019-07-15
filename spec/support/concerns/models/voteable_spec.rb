shared_examples_for 'Voteable' do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }
  # let(:klass) { described_class }

  let(:model) do
    case voteable
    when 'Question'
      question
    when 'Answer'
      answer
    else
      # nil error
    end
  end

  it '#up_rating' do
    model.change_rating(1)
    expect(model.votes.first.vote).to eq(1)
  end

  it '#cancel_vote' do
    model.votes.where(user: user).destroy_all
    expect(model.votes.count).to eq(0)
  end

  it '#down_rating' do
    model.change_rating(-1)
    expect(model.votes.first.vote).to eq(-1)
  end

  it '#rating' do
    model.votes.create(vote: 1, user: user)
    model.votes.create(vote: 1, user: user)
    model.votes.create(vote: 1, user: user)
    model.votes.create(vote: -1, user: user)
    expect(model.rating).to eq(2)
  end
end