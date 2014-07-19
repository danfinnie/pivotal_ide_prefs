require "ide_prefs/entities/pref"
require "persistence/private/file_database"
require "persistence/private/repo"

module Persistence
  module Repos
    class UserPrefsRepo < Private::Repo
      def install_prefs(prefs)
        destroy_prefs(find_matching_prefs(prefs))

        prefs.each do |pref|
          file_database.symlink(pref.id, pref.location)
        end
      end

      def destroy_installed_prefs
        destroy_prefs(installed_prefs)
      end

      def create_prefs(prefs)
        prefs.each do |pref|
          put(pref)
        end
      end

      def find_matching_prefs(prefs_to_match)
        prefs_to_match_relative_paths = prefs_to_match.collect(&:id)

        convert_files_to_prefs file_database.files_matching_relative_paths(prefs_to_match_relative_paths)
      end

      def installed_prefs
        convert_files_to_prefs file_database.symlinks
      end

      private
      def destroy_prefs(prefs)
        prefs.each do |pref|
          file_database.destroy_file(pref.id)
        end
      end
    end
  end
end
