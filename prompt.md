venue_detail_screen.dart shows "Failed to load venue" even though the backend
returns 200 with correct data. The actual API response shape is:

{
"id": "uuid",
"name": "Docker NBG",
"address": "Mall Blvd 5",
"city": "Belgrade",
"pointBalance": 0,
"rewards": [
{
"id": "uuid",
"name": "Free espresso",
"description": "Get 1 free espresso with any purchase.",
"pointsCost": 120,
"validFrom": "2026-03-17T12:22:02Z",
"validTo": "2026-06-18T12:22:02Z",
"stock": 200
}
]
}

The response is a FLAT object — NOT nested under a "venue" key.
The rewards array is directly in the root object — NOT paginated, NOT under "content".

Fix venue_detail_screen.dart to parse this exact shape:
- venue name from response['name']
- address from response['address']
- city from response['city']
- pointBalance from response['pointBalance']
- rewards from response['rewards'] as a direct List

Also check: the screen receives a venueId from GoRouter — confirm it is reading
the route parameter correctly and passing it to getVenueWithRewards(venueId).

Do not change any other files.