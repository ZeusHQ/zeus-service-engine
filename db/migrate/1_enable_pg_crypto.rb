class EnablePgCrypto < ActiveRecord::Migration[6.1]
  def up
    enable_extension 'pgcrypto'
  end
end  