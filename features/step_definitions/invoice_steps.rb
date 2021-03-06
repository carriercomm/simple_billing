When /^I add a \$(\d+\.\d+) invoice for "(.*?)"$/ do |amount, title|
  click_link("Add Invoice")
  fill_in("invoice_title", with: title)
  fill_in("invoice_amount", with: amount)
  click_button("Create Invoice")
end

Then /^I should see "(.*?)" for \$(\d+\.\d+)$/ do |title, amount|
  find('.invoices').should have_content(title)
  find('.invoices').should have_content("$#{amount}")
end

Then /^I should not see "(.*?)" for \$(\d+\.\d+)$/ do |title, amount|
  find('.invoices').should_not have_content(title)
  find('.invoices').should_not have_content("$#{amount}")
end

Then /^I should be on the admin user page for "(.*?)"$/ do |user_name|
  find("h1.main_title").should have_content("Admin for #{user_name}")
end

When /^I destroy the invoice for "(.*?)"$/ do |title|
  for_invoice(title) { click_link("Destroy") }
end

When /^I edit the invoice "(.*?)" to have:$/ do |title, table|
  for_invoice(title) { click_link("Edit") }
  fill_in("invoice_title", with: table.rows_hash['title'])
  fill_in("invoice_amount", with: table.rows_hash['amount'])
  click_button("Update Invoice")
end

Given /^I am on my user page$/ do
  visit user_path(@user)
  find("h1.main_title").should have_content("Dashboard for #{@user.username}")
end

Then /^I should see my invoices:$/ do |table|
  table.hashes.each do |row|
    step %Q(I should see "#{row['title']}" for #{row['amount']})
  end
end

When /^I open the invoice for "(.*?)"$/ do |title|
  for_invoice(title) { click_link("Show") }
end

Then /^I should be on the invoice page for "(.*?)"$/ do |title|
  find('h1.main_title').should have_content("Invoice for #{title}")
end

Then /^I should see a (pending|payable) invoice "(.*?)" for \$(\d+\.\d+)$/ do |state, title, amount|
  for_invoice(title) do
     page.should have_content(amount)
     page.should have_content(state)
  end
end

Given /^"(.*?)" has a (payable|pending) invoice "(.*?)" for \$(\d+\.\d+)$/ do |user_name, state, title, amount|
  user = User.where(username: user_name).first
  payable = state == "payable" ? true : false
  @invoice = FactoryGirl.create(:invoice, user: user, title: title, amount: amount, payable: payable)
end

When /^I send the invoice$/ do
  if @invoice
    @user = @invoice.user
  else
    @invoice = @user.invoices.first
  end
  step %Q(I am on the admin user page for "#{@user.username}")
  for_invoice do
    click_link "Send"
  end
end

def for_invoice(title = "")
  invoice = title == "" ? @invoice : Invoice.where(title: title).first
  invoice_row_id = "#invoice_#{invoice.id}"
  within(:css, invoice_row_id) { yield }
end