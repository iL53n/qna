shared_examples_for 'API Authorizable' do
  context 'unauthorized' do
    it 'return 401 status if there is no access_token' do
      do_request(method, api_path, headers: headers)
      expect(response.status).to eq 401
    end

    it 'return 401 status is acces_token is invalid' do
      do_request(method, api_path, params: { access_token: '1234' }, headers: headers)
      expect(response.status).to eq 401
    end
  end
end

shared_examples_for 'Request successful' do
  it 'return 2xx status' do
    expect(response).to be_successful
  end
end

shared_examples_for 'Return list' do
  it 'return list of resource' do
    expect(resource_response.size).to eq resource.size
  end
end

shared_examples_for 'Request_unprocessable_entity' do
  it 'return status :unprocessable_entity' do
    expect(response.status).to eq 422
  end
end

shared_examples 'Public fields' do
  it 'return all public fields' do
    attrs.each do |attr|
      expect(resource_response[attr]).to eq resource.send(attr).as_json
    end
  end
end

shared_examples 'Errors' do
  it 'return error message' do
    expect(json['errors']).to be_truthy
  end
end


