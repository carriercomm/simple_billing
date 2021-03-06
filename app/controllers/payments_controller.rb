class PaymentsController < ApplicationController
  def new
    @user = User.find(params[:user_id])
    @invoice = @user.invoices.find(params[:invoice_id])
  end

  def confirm
    user = User.find(params[:user_id])
    invoice = user.invoices.find(params[:invoice_id])
    processor = PaymentProcessor.new(invoice)
    if processor.process
      redirect_to user_path(user), :notice => "Payment Successful!"
    else
      redirect_to user_invoice_path(user, invoice), :alert => processor.customer_failure_message
    end
  end
end