require 'singleton'
require 'sqlite3'

class Databaser < SQLite3::Database

	include Singleton

	def initialize
		super("aa.db")
		self.results_as_hash = true
		self.type_translation = true
	end
end


