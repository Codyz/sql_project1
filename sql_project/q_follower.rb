require_relative 'user'

class QFollower

	# CLASS METHODS

	def self.find_by_id(id)
	  query = <<-SQL
		  SELECT *
			FROM q_followers
			WHERE q_followers.id = ?
		SQL

		q_follower = Databaser.instance.execute(query, id)[0]
		QFollower.new(q_follower)
	end

	def self.followers_for_question_id(id)
		query = <<-SQL
			SELECT users.*
			FROM users
			JOIN q_followers ON users.id=q_followers.user_id
			WHERE q_followers.question_id = ?
		SQL

		users = Databaser.instance.execute(query, id)

		users.map {|user| User.new(user)}
	end

	def self.followed_questions_for_user_id(id)
		query = <<-SQL
			SELECT questions.*
			FROM questions
			JOIN q_followers ON questions.id=q_followers.question_id
			WHERE q_followers.user_id = ?
		SQL

		questions = Databaser.instance.execute(query, id)

		questions.map {|question| Question.new(question)}
	end

	# INSTANCE METHODS

	def initialize(options = {})

		@question_id = options['question_id']
		@user_id     = options['user_id']
		@id          = options['id']
	end
end
