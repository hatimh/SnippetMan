require 'test_helper'

class GistTest < ActiveSupport::TestCase
  test "should be invalid without description" do
    @gist = Gist.new(:files => [{ name: 'file-name', content: 'content'}])
    assert @gist.invalid?
    assert @gist.errors.messages[:description]
  end


  test "should be invalid with no files" do
    @gist = Gist.new(:description => 'description')
    assert @gist.invalid?
    assert @gist.errors.messages[:files]
  end

  test "should be invalid with no content in files" do
    @gist = Gist.new(
      :description => 'description',
      :files => [{
        name: 'file-name',
        content: ''
      }]
    )

    assert @gist.invalid?
    assert @gist.errors.messages[:files]
  end

  test "should be invalid with no name in files" do
    @gist = Gist.new(
      :description => 'description',
      :files => [{
        name: '',
        content: 'content'
      }]
    )

    assert @gist.invalid?
    assert @gist.errors.messages[:files]
  end

  test "should be valid if all details are provided" do
    @gist = Gist.new(
      :description => 'description',
      :files => [{
        name: 'file-name',
        content: 'content'
      }]
    )

    assert @gist.valid?
  end
end
