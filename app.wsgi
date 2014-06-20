import glob, os, sys


project_dir = os.path.dirname(__file__)
project_name = os.path.basename(project_dir)
virtualenv = '/usr/lib/virtualenvs/{0}'.format(project_name)
site_packages = glob.glob('{0}/lib/*/site-packages'.format(virtualenv))[0]

sys.path.insert(0, project_dir)
sys.path.insert(0, site_packages)


from app import app as application


if not application.debug:
    import logging
    this_dir = os.path.dirname(__file__)
    log_file = os.path.join(this_dir, 'app/production.log')
    file_handler = logging.FileHandler(log_file)
    file_handler.setLevel(logging.WARNING)
    application.logger.addHandler(file_handler)
