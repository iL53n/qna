shared_examples_for 'Search' do
  Services::Search::RESOURCE.each do |resource|
    context  "" do
      scenario "looking for in #{resource}" do
        ThinkingSphinx::Test.run do
          within '.search_form' do
            fill_in 'q', with: object.send(attr)
            select "#{resource}", from: 'resource'
            click_on 'Search'
          end

          within '.search_result' do
            if resource == 'All' || resource == "#{context}"
              expect(page).to have_content object.send(attr)

              objects.drop(1).each do |q|
                expect(page).to_not have_content q.send(attr)
              end
            else
              objects.each do |q|
                expect(page).to_not have_content q.send(attr)
              end
            end
          end
        end
      end
    end
  end
end
