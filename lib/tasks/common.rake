namespace :data do

  desc "Data mapping between ActivationCallRequest and Projects"
  task :map => :environment do
    Rake::Task["data:create_projects"].invoke
    Rake::Task["data:build_association"].invoke
  end

  desc "Create Projects form ActivationCallRequest"
  task :create_projects => :environment do
    project_names = ActivationCallRequest.all.collect(&:project_name).uniq
    project_names.each do |project_name|
      Project.create(name: project_name)
    end
  end

  desc "Build association between ActivationCallRequest and Project"
  task :build_association => :environment do
    Project.all.each do |project|
      requests = ActivationCallRequest.where(project_name: project.name)
      requests.update_all(project_id: project.id)
    end
  end

  desc "Reset Project table"
  task :reset_projects => :environment do
    Project.delete_all
  end


end