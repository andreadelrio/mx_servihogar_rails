class Provider < ActiveRecord::Base
  belongs_to :category
  has_secure_password
  has_many :pictures, as: :imageable
  accepts_nested_attributes_for :pictures 
  validates_presence_of :email, :category_id, :name, :last_name_1, :last_name_2, :phone, :dni
  validates_uniqueness_of :email, format: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates_uniqueness_of :dni
  belongs_to :category
  has_many :localizations
  has_many :locations, through: :localizations
  validates :locations, :presence => true
  validates :dni, length: { is: 13, message: "debe tener 13 dígitos." }
  validates_format_of :dni,
    with: /[0-9]+\z/i,
    message: %Q[solo puede incluir números (0-9).]
  validates_format_of :phone,
    with: /\A[0-9\-]+\z/,
    message: %Q[solo puede incluir números (0-9) y guiones "-".]  
  validate :fields_a_and_b_are_equal, on: :create

  def prov_locations
    if self.locations.count > 2
      return self.locations.limit(2).map(&:name).join(", ") + ", entre otros."
    else
      return self.locations.map(&:name).join(", ")
    end
  end

  def prov_locations_modal
    if self.locations.count == Location.all.count 
      return "Todos los municipios de México DF."
    else
      return self.locations.map(&:name).join(", ")
    end
  end

  protected

  def fields_a_and_b_are_equal
    if self.email.present?
      unless self.email == self.email_c
        errors.add(:email_c, 'debe coincidir con el correo electrónico')
      end
    end  
  end  

end
