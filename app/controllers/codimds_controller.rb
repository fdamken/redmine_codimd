class CodimdsController < ApplicationController
  before_action :require_login

  rescue_from Query::StatementInvalid, with: :query_statement_invalid

  helper :queries
  helper :additionals_queries

  include QueriesHelper
  include AdditionalsQueriesHelper

  helper :sort
  include SortHelper

  def show
    sort_init 'updatedAt', 'desc'
    sort_update %w[title createdAt updatedAt]

    @limit = per_page_option

    scope = CodimdPad.pads

    @codimd_pad_count = scope.count
    @codimd_pad_pages = Paginator.new @codimd_pad_count, @limit, params['page']
    @offset ||= @codimd_pad_pages.offset
    @codimd_pads = scope.order(CodimdPad.fix_sort_clause(sort_clause))
                        .limit(@limit)
                        .offset(@offset)
  end
end
