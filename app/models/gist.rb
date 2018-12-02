class Gist
  include ActiveModel::Model, ActiveModel::Validations
  attr_accessor :description, :files, :id
  attr_reader :public

  validates_presence_of :description
  validate :files_not_empty

  def initialize(args = { description: '', files: [] })
    @description = args[:description] || ''
    @files = args[:files] || []
    @public = false
  end

  private def files_not_empty
    if !files || files.size === 0
      self.errors[:files] << 'Must contain atleast one file.'
    else
      with_content = files.select { |file| !file[:content].blank? && !file[:name].blank? }

      if with_content.size === 0
        self.errors[:files] << 'Files must have name and content.'
      end
    end
  end
end
