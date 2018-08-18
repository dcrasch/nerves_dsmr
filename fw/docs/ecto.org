* Select Stream
alias Ui.{Repo, Reading}
import Ecto.Query
Repo.transaction fn -> (from p in Reading, select: p) |> Repo.stream  |> Enum.each(fn x->IO.puts x.id end) end

iex(22)> Repo.transaction fn -> (from p in Reading, select: p) |> Repo.stream  |> Stream.map(&(to_string &1.id)) |> Enum.reduce(fn (a,b) -> a<>b end) end


* Chunked sql Example

  Ecto.Query.from(u in Users, order_by: [asc: :created_at])
  |> Repo.chunk(100)
  |> Stream.map(&process_batch_of_users)
  |> Stream.run()
"""
@spec chunk(Ecto.Queryable.t, integer) :: Stream.t
def chunk(queryable, chunk_size) do
  chunk_stream = Stream.unfold(1, fn page_number ->
    page = Repo.paginate(queryable, page: page_number, page_size: chunk_size)
    {page.entries, page_number + 1}
  end)
  Stream.take_while(chunk_stream, fn [] -> false; _ -> true end)
end

* json poison
https://coderwall.com/p/fhsehq/fix-encoding-issue-with-ecto-and-poison
* custom sql
Repo.all(from p in Reading, where:
fragment("strftime(\"%H\",?)=\"12\"",p.timestamp) and p.id<3600)
