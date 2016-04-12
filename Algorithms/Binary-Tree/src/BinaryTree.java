class Node {

}

public class BinaryTree {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		
		String name = "Pierre Deludet\n";
		String lastName = "";
		
		for (int i = 0; i < name.length(); i ++) {
			
			if (Character.toString(name.charAt(name.length() - i - 1)).equals(" ")) {
				
				lastName = name.substring(name.length()-i, name.length());
				
			}
			
			System.out.print(lastName);
			
		}
		
	}

}
