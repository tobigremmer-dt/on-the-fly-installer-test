#!/usr/bin/python3

class FilterModule(object):
  ''' Nested dict filter '''

  def filters(self):
    return {
      'useCaseExtSrcToName': self.useCaseExtSrcToName,
      'useCaseExtSrcToWorkdir': self.useCaseExtSrcToWorkdir
    }

  def useCaseExtSrcToName(self, use_case_ext_src):
    slug = use_case_ext_src.split('/')[-1]
    name = slug.replace('.git', '')
    return name

  def useCaseExtSrcToWorkdir(self, use_case_ext_src, ace_box_user):
    name = self.useCaseExtSrcToName(use_case_ext_src)
    work_dir = f'/home/{ace_box_user}/.ace/tmp/{name}'
    return work_dir
