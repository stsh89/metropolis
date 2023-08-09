module ProjectsHelper
  def project_create_time(create_time)
    create_time.strftime('%Y-%m-%d %H:%M:%S')
  end
end
