require 'conflux/api/abstract_api'

class Conflux::Api::Users < Conflux::Api::AbstractApi

  def extension
    '/users'
  end

  def login(email, password)
    post("#{extension}/login",
      data: {
        email: email,
        password: password
      },
      auth_required: false,
      error_message: 'Authentication failed.'
    )
  end

  def join(email, password)
    post("#{extension}/join",
      data: {
        email: email,
        password: password
      },
      auth_required: false,
      error_message: 'Failed to join Conflux. Unknown error.'
    )
  end

  def apps
    get("#{extension}/apps")
  end

  def teams
    get("#{extension}/teams")
  end

  def for_team(team_slug)
    get('/teams/users',
      data: { team_slug: team_slug }
    )
  end

  def invite(email, team_slug)
    post('/team_users/invite',
      data: {
        email: email,
        team_slug: team_slug
      }
    )
  end

end