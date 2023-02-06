const pagingContacts = r'''

query paginationContacts($id: ID!, $first: Int!, $after: String!) {
  paginationContacts(id: $id) {
    id
    contactsConnection(first:$first after:$after) {
      totalCount
      edges {
        node {
          id
          name
        }
        cursor
      }
      pageInfo {
        hasNextPage
      }
    }
  }
}

''';
