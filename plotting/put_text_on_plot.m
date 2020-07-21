function varargout = put_text_on_plot(txt_str, varargin)
%%put_text_on_plot allows the user to interactively put text onto a plot,
%%at their location of choice. The first input, txt_str, is the string to
%%be placed on the plot. This is the only required input. The remaining
%%inputs are name-value pairs that adjusts the text style.
%
%
%Optional arguments:
%   [x, y]      - Coordinate position of the desired text location
%   'Prompt'    - A prompt to be displayed to the user each time a position
%                 is requested
%   formatting  - Any name-value pairs that are allowed to the built-in
%                 Matlab text() function
%
%NOTE: Do not input both a 'Prompt' and the [x, y] coordinates. Choose one.
%
%Example:
%   txt_str = 'hello world';
%   figure
%   put_text_on_plot(txt_str)
%
%Example:
%   figure
%   put_text_on_plot('hello_world', [0.5, 0.5], 'color', 'red')
%
%Example:
%   figure
%   put_text_on_plot('hello_world', 'Prompt', 'Left-click to place text; right-click to end function', 'color', 'green', 'fontweight', 'bold')


nargoutchk(0,1)
if ~isstring(txt_str) && ~ischar(txt_str)
	error('The first input must be a string!')
end

% % Interactive tells the function whether the user wants interactive mode (true) or not (false) 
% % We initialize interactive to be true, but if it isn't then it will be replaced with false later
interactive = true; 

formatting_options = {}; % Initialize
if ~isempty(varargin) % Check if there are entries in varargin (if there are optional, non-mandatory arguments)
    idx = 1; % Use an index to bookkeep which varagins will be formatting options	
    if isnumeric(varargin{1}) && length(varargin{1}) == 2 % If the first entry in varargin is type numeric, and it is of length 2
    	interactive = false;  % User provided a pair of coordinates, so we know this will be non-interactive
    	idx = 2; % Bookmarks where the name-value pairs would start
        pos = varargin{1};
    elseif strcmpi(varargin{1}, 'Prompt') % If the first entry in varargin is 'Prompt' (irresepective of any capitalization)
		prompt = varargin{2}; 	
    	idx = 3; % This index bookmarks where the name-value pairs would start
    end
    
    % % Formatting_Options = rest of varargin
    if length(varargin) >= idx
       formatting_options = varargin(idx:end);
    end
end

hold on
if interactive == true 
    % % Then the user did not provide a position, and we will ask them for it
    while 1 % Runs until the user right clicks
        if exist('prompt','var')  
            disp(prompt) % Then display the prompt text on the command line, which is stored in the entry right after 'Prompt'  
        end
        pos = ginput(1); % User selects 1 pair of coordinates, we store them in coords variable
        selection = get(gcf, 'SelectionType'); 
        if strcmpi(selection, 'alt') % Check if the user input was a right click
            break
        end
        if exist('text_obj','var')
            delete(text_obj) % Delete, as we will overwrite it
        end
        text_obj = text(pos(1), pos(2), txt_str, formatting_options{:}); % output the text onto the current figure, and store the object in text_obj, which the assignment asks for
    end % while
    fprintf('Text location is [%f %f]\n', pos(1), pos(2))
else
    % % User provided the position, so use it directly
    text_obj = text(pos(1), pos(2), txt_str, formatting_options{:});
end % interactive == true statement

if nargout == 1 
    varargout{1}= text_obj;
end

end % function