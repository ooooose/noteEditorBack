up:
	docker compose up -d

build:
	docker compose build
	
stop:
	docker compose stop

down:
	docker compose down

ps:
	docker compose ps -a

logs:
	docker compose logs -f back

attach:
	docker compose attach back

bundle:
	docker compose run --rm back bundle install --without production

g-model:
	docker compose run --rm back bin/rails g model $(NAME)

d-model:
	docker compose run --rm back bin/rails d model $(NAME)

g-controller:
	docker compose run --rm back bin/rails g controller $(NAME)

d-controller:
	docker compose run --rm back bin/rails d controller $(NAME)

g-serializer:
	docker compose run --rm back bin/rails g serializer $(NAME)

d-serializer:
	docker compose run --rm back bin/rails d serializer $(NAME)

migrate:
	docker compose run --rm back bin/rails db:migrate

fresh:
	docker compose run --rm back bin/rails db:migrate:reset

seed:
	docker compose run --rm back bin/rails db:seed

rubocop:
	docker compose run --rm back bundle exec rubocop -a

rspec:
	docker compose run --rm back bundle exec rspec

routes:
	docker compose run --rm back bin/rails routes

console:
	docker compose run --rm back bin/rails c

shell:
	docker compose exec back bash
