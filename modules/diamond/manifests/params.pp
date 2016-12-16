class diamond::params(
  $diamond_prefix = '/opt/local/diamond',
  $metric_suffix = hiera('metric_suffix'),
  $wavefront_endpoint = hiera('wavefront_endpoint'),
)
{}
