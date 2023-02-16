defmodule VmsWeb.InvalidLive do
  use Phoenix.LiveView
  alias Phoenix.LiveView.JS

  def render(assigns) do
    ~H"""
    <div class="flex justify-center">
      <div class="flex flex-col">
        <div class="basis-1/3 flex flex-col">
          <div
            tabindex="0"
            phx-click={JS.toggle(in: "collapse-open", out: "collapse-close")}
            class="collapse collapse-open collapse-plus border border-base-300 bg-base-100 rounded-box"
          >
            <div class="collapse-title text-xl font-medium">
              Event info
            </div>
            <div class="collapse-content">
              <div class="overflow-x-auto">
                <table class="table table-zebra w-full">
                  <!-- head -->
                  <thead>
                    <tr>
                      <th></th>
                      <th>Name</th>
                      <th>Job</th>
                      <th>Favorite Color</th>
                    </tr>
                  </thead>
                  <tbody>
                    <!-- row 1 -->
                    <tr>
                      <th>1</th>
                      <td>Cy Ganderton</td>
                      <td>Quality Control Specialist</td>
                      <td>Blue</td>
                    </tr>
                    <!-- row 2 -->
                    <tr>
                      <th>2</th>
                      <td>Hart Hagerty</td>
                      <td>Desktop Support Technician</td>
                      <td>Purple</td>
                    </tr>
                    <!-- row 3 -->
                    <tr>
                      <th>3</th>
                      <td>Brice Swyre</td>
                      <td>Tax Accountant</td>
                      <td>Red</td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
