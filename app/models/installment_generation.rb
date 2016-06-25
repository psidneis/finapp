class InstallmentGeneration

  attr_reader :launch, :user

  def initialize(launch, user)
    @launch = launch
    @launch.user = user
  end

  def create
    if @launch.save
      @launch.choose_type_launch
      @launch.update_last_installment
      @launch.notify_user_groups if @launch.group.present?
    end
  end



  private

end
